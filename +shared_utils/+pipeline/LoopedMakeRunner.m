classdef LoopedMakeRunner < handle
  
  properties (Access = public)
    
    %   LOG_LEVEL
    %
    %     log_level controls what output is logged to the console.
    %     Options are 'info', 'warn', 'progress', or 'off'. 'info' logs 
    %     everything; 'warn' logs warnings, only; 'progress' logs progress, 
    %     only; 'off' suppresses output entirely.
    log_level = 'info';
    
    %   FUNC_NAME
    %
    %     func_name is used when printing the progress of the looped
    %     runner, providing a more descriptive indication of what's
    %     processing.
    func_name = '';
    
    %   FILES_AGGREGATE_TYPE
    %
    %     files_aggregate_type gives the class of the aggregate file
    %     structure passed as the first argument to the LoopedMakeRunner's
    %     main function. Options are 'struct' (default) or 'containers.Map'.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.run,
    %       shared_utils.general.get
    files_aggregate_type = 'struct';
    
    %   INPUT_DIRECTORIES
    %
    %     input_directories is a cell array of strings or a char vector
    %     specifying full path(s) to the directory(ies) from which files 
    %     will be loaded.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.output_directory
    input_directories = {};
    
    %   OUTPUT_DIRECTORY
    %
    %     output_directory is a char vector specifying the full path to the
    %     directory in which the single output from the LoopedMakeRunner's
    %     main function will be saved.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.run
    output_directory = '';
    
    %   IS_PARALLEL
    %
    %     is_parallel indicates whether to attempt to run the main function
    %     in parallel. The function will only run in parallel if a valid
    %     parpool instance already exists. Default is true.
    is_parallel = true;
    
    %   OVERWRITE
    %
    %     overwrite indicates whether to allow existing files in
    %     `output_directory` to be overwritten. Default is false.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.output_directory
    overwrite = false;
    
    %   SAVE
    %
    %     save indicates whether to attempt to save the output of the main
    %     function. Default is true.
    save = true;
    
    %   CALL_WITH_IDENTIFIER
    %
    %     call_with_identifier indicates whether to call the main function
    %     with an additional argument 'identifier', the char vector 
    %     identifier associated with the current file aggregate. Default is
    %     false.
    %
    %     See also
    %       shared_utils.pipeline.LoopedMakeRunner.call_with_filepath
    call_with_identifier = false;
    
    %   CALL_WITH_FILEPATH
    %
    %     call_with_filepath indicates whether to call the main function
    %     with an additional argument 'filepath', the char vector absolute
    %     path to the primary loaded file; i.e., the file associated with
    %     the first directory in `input_directories`. Default is false.
    %
    %     See also
    %       shared_utils.pipeline.LoopedMakeRunner.call_with_identifier
    call_with_filepath = false;
    
    %   KEEP_OUTPUT
    %
    %     keep_output indicates whether to store the output of each call to
    %     the LoopedMakeRunner's main function in the output of `run`.
    %     Default is false.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.run
    keep_output = false;
    
    %   LOAD_FUNC
    %
    %     load_func is a handle to a function that receives a char vector
    %     filename and returns a single output (usually a struct), and is
    %     the function used to load files from `input_directories`. Default
    %     is shared_utils.io.fload.
    %
    %     See also shared_utils.io.fload
    load_func = @shared_utils.io.fload;
    
    %   SAVE_FUNC
    %
    %     save_func is a handle to a function that receives a char vector
    %     filename and the to-be-saved data, and returns no outputs. It is
    %     the function used to save files into `output_directory`. Default
    %     is shared_utils.io.psave.
    %
    %     See also shared_utils.io.psave
    save_func = @shared_utils.io.psave;
    
    %   GET_IDENTIFIER_FUNC
    %
    %     get_identifier_func is a handle to a function that receives the
    %     contents of a file (as loaded with `load_func`) and the char 
    %     vector absolute path to that file, and returns a char vector
    %     identifier for that file. The identifier is generally (but need
    %     not be) the same as the filename. Default is a function that
    %     attempts to access an 'identifier' field in the loaded file. This
    %     will generate an error if the loaded file is not a struct or
    %     does not have an 'identifier' field; in this case you must
    %     specify this function manually.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.get_filename_func
    get_identifier_func = @shared_utils.pipeline.LoopedMakeRunner.default_get_identifier_func;
    
    %   GET_FILENAME_FUNC
    %
    %     get_filename_func is a handle to a function that receives a char
    %     vector file identifier and returns a char vector filename. The
    %     filename is used to save the output of the main function in
    %     `output_directory`. Default is a function that simply returns the
    %     identifier unmodified.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.get_identifier_func
    get_filename_func = @shared_utils.pipeline.LoopedMakeRunner.noop;
    
    %   FILTER_FILES_FUNC
    %
    %     filter_files_func is a handle to a function that receives a cell
    %     array of absolute file paths and returns a cell array that is the
    %     subset (or complete set) of those file paths that meet some 
    %     condition (e.g., contain a certain string). Only the resulting 
    %     file paths will be used when loading files. Default is a function 
    %     that simply returns the result of `find_files_func` unmodified.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.find_files_func
    filter_files_func = @shared_utils.pipeline.LoopedMakeRunner.noop;
    
    %   FIND_FILES_FUNC
    %
    %     find_files_func is a handle to a function that receives a single 
    %     char vector absolute directory path and returns a cell array of 
    %     absolute paths to files in that directory. Note that this 
    %     function will be called only once, and with the first entry in 
    %     `input_directories`. Default is a function that returns a cell
    %     array of absolute paths to .mat files in a given directory.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.filter_files_func,
    %       shared_utils.io.find
    find_files_func = @shared_utils.pipeline.LoopedMakeRunner.default_find_files_func;
    
    %   GET_DIRECTORY_NAME_FUNC
    %
    %     get_directory_name_func is a handle to a function that receives a
    %     char vector absolute directory path and returns a char vector
    %     directory name. For each `input_directory`, the result of this
    %     function gives the name of the corresponding entry into the 
    %     files aggregate passed as the first argument to the main function. 
    %     Default is a function that obtains a folder name from a directory 
    %     path.
    %
    %     For example, if `input_directories` contains two entries:
    %     { '/path/to/folder1', '/path/to/folder2' }
    %
    %     then, by default, the main function will be called with a struct
    %     whose fields are 'folder1' and 'folder2'.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.run     
    get_directory_name_func = @shared_utils.pipeline.LoopedMakeRunner.get_directory_name;

    %   MAIN_ERROR_HANDLER
    %
    %     main_error_handler controls how errors thrown by the main
    %     function (the function passed as an argument to `run`) are
    %     handled. This property can be one of 'warn', 'error', or a handle 
    %     to a function that accepts an MException as input and returns no 
    %     outputs. If the value is 'warn', caught errors are conditionally 
    %     printed as warnings to the console, depending on the current 
    %     `log_level`. If the value is 'error', caught errors are rethrown, 
    %     stopping execution.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.io_error_handler,
    %       shared_utils.pipeline.LoopedMakeRunner.log_level
    main_error_handler = 'warn';
    
    %   IO_ERROR_HANDLER
    %
    %     io_error_handler controls how errors thrown in the process of
    %     loading or saving files are handled. This property can be one of 
    %     'warn', 'error', or a handle to a function that accepts an 
    %     MException as input and returns no outputs. If the value is 
    %     'warn', caught errors are conditionally printed as warnings to 
    %     the console, depending on the current `log_level`. If the value 
    %     is 'error', caught errors are rethrown, stopping execution.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner.main_error_handler,
    %       shared_utils.pipeline.LoopedMakeRunner.log_level    
    io_error_handler = 'warn';
    
    %   ENABLE_ESCAPE_LISTENER
    %
    %     enable_escape_listener is a logical scalar indicating whether to
    %     listen for an escape key-press during the main processing loop.
    %     If the escape key is pressed, the runner will abort processing
    %     further files, and will return the processed results.
    %
    %     Key listening depends on Psychtoolbox; if Psychtoolbox is not
    %     installed, enabling this feature has no effect. Aborting is also
    %     not possible if the runner is running in parallel.
    %
    %     See also shared_utils.pipeline.LoopedMakeRunner
    enable_escape_listener = false;
  end
  
  properties (Access = private)
    first_input_directory = '';
    remaining_input_directories = {};
    failed_to_check_key_input = false;
  end
  
  properties (Access = private, Constant = true)
    log_levels = { 'info', 'warn', 'progress', 'off' };
    error_handler_str_types = { 'warn', 'error' };
    files_aggregate_types = { 'struct', 'containers.Map' };
  end
  
  methods    
    function obj = LoopedMakeRunner(varargin)
      
      %   LOOPEDMAKERUNNER -- Create LoopedMakeRunner instance.
      %
      %     LoopedMakeRunner exposes an interface for loading, processing,
      %     and saving files, treating the file system like a rudimentary
      %     database.
      %
      %     This class is best suited to a data structure in which ordinary
      %     directories function as fields of a table, with filenames
      %     therein as string keys / identifiers that are consistent across
      %     tables.
      %
      %     For example, the following folder structure is a good candidate
      %     for making use of LoopedMakeRunner:
      %
      %     data/
      %       meta/
      %         run1_session1.mat
      %         run2_session1.mat
      %       performance/
      %         run1_session1.mat
      %         run2_session1.mat
      %
      %     In this example, the 'meta' and 'performance' directories 
      %     contain meta-data and subject performance-data, respectively, 
      %     for two runs of some experiment. In both directories, filenames
      %     are unique identifiers that refer to a given run. LoopedMakeRunner 
      %     can be used to call a function that operates on files 
      %     associated with each identifier (serially or in parallel), 
      %     and to potentially produce a new "table" as an output. 
      %
      %     Each identifier conceptually refers to a "unit" that can be 
      %     (must be) processed in isolation, without using data from any 
      %     other "unit." If, for example, your data are structured such 
      %     that 'run1_session1.mat' and 'run2_session1.mat' need to 
      %     be loaded together, then LoopedMakeRunner may not be the
      %     correct tool.
      %
      %     See also shared_utils.pipeline.LoopedMakeRunner.run,
      %       shared_utils.io.fload, shared_utils.io.psave
      
      try
        shared_utils.general.parseobject( obj, varargin );
      catch err
        throw( err );
      end
    end
    
    function set_skip_existing_files(obj, output_directory, ext)
      
      %   SET_SKIP_EXISTING_FILES -- Configure the runner to skip files that
      %     already exist in the output folder.
      %
      %     set_skip_existing_files( runner, output_directory ); configures
      %     the `runner` to avoid processing mat-file identifiers that are 
      %     already present in `output_directory`. If `output_directory` 
      %     does not exist, or is the empty string (''), this function has 
      %     no effect.
      %
      %     set_skip_existing_files( runner ), with no additional inputs,
      %     works as above, except that the output_directory is the value
      %     of `obj.output_directory`.
      %
      %     set_skip_existing_files( ..., extension ) uses `extension` to
      %     look for files in `output_directory`, instead of '.mat'.
      %
      %     See also shared_utils.pipeline.LoopedMakeRunner
      
      if ( nargin < 3 )
        ext = '.mat';
      end
      
      if ( nargin < 2 )
        output_directory = '';
        use_given_output_directory = false;
      else
        use_given_output_directory = true;
      end
      
      filter_func = obj.filter_files_func;
      obj.filter_files_func = @(x) skip_files_func(filter_func(x));
      
      function files = skip_files_func(files)
        
        if ( use_given_output_directory )
          od = output_directory;
        else
          od = obj.output_directory;
        end
        
        if ( isempty(od) )
          return
        end
        
        try
          od = char( od );
          
          if ( ~shared_utils.io.dexists(od) )
            return
          end
          
          current_files = shared_utils.io.dirnames( od, ext );
          
          % Ignore files containing any of `current_files`.
          files = shared_utils.io.filter_files( files, {}, current_files );
        catch e
          % Ignore errors.
        end
      end
    end
    
    function convert_to_non_saving_with_output(obj)
      
      %   CONVERT_TO_NON_SAVING_WITH_OUTPUT
      %
      %     Reconfigure instantiated object to operate without saving
      %     output of main function.
      %
      %     See also shared_utils.pipeline.LoopedMakeRunner.make_non_saving_with_output
      
      obj.save = false;
      obj.keep_output = true;
      obj.files_aggregate_type = 'containers.Map';
    end
    
    function set_error_handler(obj, val)
      
      %   SET_ERROR_HANDLER -- Set error handling behavior.
      %
      %     This function sets the error handling behavior for both file
      %     loading/saving and the main routine.
      %
      %     See also shared_utils.pipeline.LoopedMakeRunner.main_error_handler,
      %       shared_utils.pipeline.LoopedMakeRunner.io_error_handler
      
      obj.main_error_handler = val;
      obj.io_error_handler = val;
    end
    
    function res = run(obj, func, varargin)
      
      %   RUN -- Run main function.
      %
      %     res = obj.run( func ); calls the function `func` with input
      %     `files`, where `files` is a struct or containers.Map object
      %     with an entry for each directory in `obj.input_directories`, 
      %     separately for each unique filename obtained from 
      %     `obj.find_files_func`.
      %
      %     res = obj.run( func, arg1, arg2, ... argN ) calls `func` with
      %     `files` as a first input, as above, but also with arguments
      %     `arg1`, `arg2`, ... `argN`.
      %     
      %     Output `res` is an array of struct indicating the status of
      %     processing each unique file. `res` has fields 'success', 
      %     'message', 'error_identifier', 'file_identifier',
      %     'primary_input_filename', 'output_filename', and 'saved'.
      %
      %     See also shared_utils.pipeline.LoopedMakeRunner
      
      validateattributes( func, {'function_handle'}, {}, 'run', 'func' );
      
      obj.handle_input_directories();
      obj.log_message( newline, 'info', false );

      try
        input_filenames = obj.get_input_filenames();
      catch err
        obj.handle_error( err, 'io_error_handler' );
        
        res = obj.get_outputs_empty_inputs();
        
        return
      end
      
      if ( isempty(input_filenames) )
        res = obj.get_outputs_empty_inputs();
        return
      end
      
      if ( obj.use_parallel() )
        res = obj.parfor_runner( input_filenames, func, varargin );
      else
        res = obj.for_runner( input_filenames, func, varargin );
      end
    end
    
    function set.main_error_handler(obj, val)      
      try
        obj.main_error_handler = obj.try_get_error_handler( val );
      catch err
        throw( err );
      end
    end
    
    function set.io_error_handler(obj, val)
      try
        obj.io_error_handler = obj.try_get_error_handler( val );
      catch err
        throw( err );
      end
    end
    
    function set.input_directories(obj, val)
      validateattributes( val, {'cell', 'char'}, {}, 'input_directories', 'input_directories' );
      obj.input_directories = shared_utils.cell.ensure_cell( val );
    end
    
    function set.output_directory(obj, val)
      validateattributes( val, {'char'}, {}, 'output_directory', 'output_directory' );
      obj.output_directory = val;
    end
    
    function set.get_identifier_func(obj, val)
      func = 'get_identifier_func';
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function set.get_directory_name_func(obj, val)
      func = 'get_directory_name_func';
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function set.filter_files_func(obj, val)
      func = 'filter_files_func';
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function set.load_func(obj, val)
      func = 'load_func';
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function set.save_func(obj, val)
      func = 'save_func';
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function set.get_filename_func(obj, val)
      func = 'get_filename_func';
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function set.find_files_func(obj, val)
      func = 'find_files_func';
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function set.is_parallel(obj, val)
      func = 'is_parallel';
      validateattributes( val, {'logical'}, {'scalar'}, func, func );
      obj.is_parallel = val;
    end
    
    function set.call_with_identifier(obj, val)
      func = 'call_with_identifier';
      validateattributes( val, {'logical'}, {'scalar'}, func, func );
      obj.call_with_identifier = val;
    end
    
    function set.call_with_filepath(obj, val)
      func = 'call_with_filepath';
      validateattributes( val, {'logical'}, {'scalar'}, func, func );
      obj.call_with_filepath = val;
    end
    
    function set.keep_output(obj, val)
      func = 'keep_output';
      validateattributes( val, {'logical'}, {'scalar'}, func, func );
      obj.keep_output = val;
    end
    
    function set.overwrite(obj, val)
      func = 'overwrite';
      validateattributes( val, {'logical'}, {'scalar'}, func, func );
      obj.overwrite = val;
    end
    
    function set.log_level(obj, val)      
      obj.log_level = validatestring( val, obj.log_levels );
    end
    
    function set.files_aggregate_type(obj, val)
      obj.files_aggregate_type = validatestring( val, obj.files_aggregate_types );
    end
    
    function set.enable_escape_listener(obj, val)
      func = 'enable_escape_listener';
      validateattributes( val, {'logical'}, {'scalar'}, func, func );
      obj.enable_escape_listener = val;
    end
  end
  
  methods (Access = private)
    
    function tf = check_should_escape(obj)
      tf = false;
      
      if ( ~obj.enable_escape_listener || obj.is_parallel || obj.failed_to_check_key_input )
        return
      end
      
      try
        [key_pressed, ~, key_code] = KbCheck();
        
        if ( key_pressed && key_code(KbName('escape')) )
          tf = true;
        end
      catch err
        obj.failed_to_check_key_input = true;
      end
    end
    
    function tf = use_parallel(obj)
      try
        tf = obj.is_parallel && ~isempty( gcp('nocreate') );
      catch err
        % Ignore missing parallel toolbox.
        tf = false;
      end
    end
    
    function full_filename = get_output_file_parts(obj, identifier)
      full_filename = fullfile( obj.output_directory, identifier );
    end
    
    function should_skip = conditional_skip_file(obj, output_filename, identifier)
      should_skip = obj.save && shared_utils.io.fexists( output_filename ) && ~obj.overwrite;
      
      if ( should_skip )
        % false to not print newline
        obj.log_message( ' | Skipping: already exists.', 'info', false );
      end
    end
    
    function [file, identifier] = get_primary_file(obj, filename)
      file = obj.load_func( filename );
      identifier = obj.get_identifier_func( file, filename );
    end
    
    function files = get_files(obj, first_input_file, identifier)
            
      first_dir_name = obj.get_directory_name_func( obj.first_input_directory );
      rem_dirs = obj.remaining_input_directories;
      
      files = obj.get_files_aggregate();
      files = shared_utils.general.set( files, first_dir_name, first_input_file );
      
      for i = 1:numel(rem_dirs)
        rem_dir = rem_dirs{i};
        rem_dir_name = obj.get_directory_name_func( rem_dirs{i} );
        
        c_file = obj.load_func( fullfile(rem_dir, identifier) );
        
        files = shared_utils.general.set( files, rem_dir_name, c_file );
      end
    end
    
    function v = try_get_error_handler(obj, val)
      if ( ischar(val) )
        v = validatestring( val, obj.error_handler_str_types );
      else
        validateattributes( val, {'function_handle'}, {} );
        assert( nargin(val) == 1 ...
          , 'An error handler function must accept a single argument.' );
        v = val;
      end
    end
    
    function res = main_wrapper(obj, filename, func, func_inputs)
      
      %   MAIN_WRAPPER -- Call main function for one file identifier.
      %
      %     This is the main routine.
      
      res = obj.get_default_output_status( filename );
      
      identifier = '';
      
      try
        % try to load the primary file -- the file from which the
        % identifier will be derived.
        
        [primary_file, identifier] = obj.get_primary_file( filename );
        
      catch err
        obj.handle_error( err, 'io_error_handler' );
        
        res = obj.assign_error_struct( res, err, identifier );
        return
      end
      
      res.file_identifier = identifier;
      
      output_filename = obj.get_output_file_parts( obj.get_filename_func(identifier) );
      
      res.output_filename = output_filename;
      
      % Check whether to return early if not overwriting an existing file.
      if ( obj.conditional_skip_file(output_filename, identifier) )
        return
      end
      
      try
        % obtain all files as an aggregate struct. `files` contains the
        % primary file as well as any additional files obtained from
        % additional input directories (beyond the first).
        files = obj.get_files( primary_file, identifier );
      catch err
        obj.handle_error( err, 'io_error_handler' );
        
        res = obj.assign_error_struct( res, err, identifier );
        return
      end
      
      try
        % call the function `func` with `files` and `func_inputs`. `func`
        % should return one output, which will be conditionally saved in 
        % the directory given by `obj.output_directory`, depending on the
        % state of `obj.overwrite` and `obj.save`.
        
        conditional_inputs = {};
        
        if ( obj.call_with_identifier )
          conditional_inputs{end+1} = identifier;
        end
        
        if ( obj.call_with_filepath )
          conditional_inputs{end+1} = filename;
        end
        
        out_file = func( files, conditional_inputs{:}, func_inputs{:} );
      
        if ( obj.save )
          shared_utils.io.require_dir( obj.output_directory );
          obj.save_func( output_filename, out_file );
          
          res.saved = true;
        end
        
        % conditionally return the output of `func`.
        if ( obj.keep_output )
          res.output = out_file;
        end
      catch err        
        obj.handle_error( err, 'main_error_handler' );
        
        res = obj.assign_error_struct( res, err, identifier );
      end
    end
    
    function handle_error(obj, err, kind)
      
      func_or_kind = obj.(kind);
      
      if ( ischar(func_or_kind) )
        switch ( func_or_kind )
          case 'error'
            throwAsCaller( err );
          case 'warn'
            obj.log_message( sprintf('\n%s: %s', kind, err.message), 'warn' );
          otherwise
            error( 'Unhandled error kind: "%s".', func_or_kind );
        end
      else
        func_or_kind( err );
      end
      
    end
    
    function outs = parfor_runner(obj, filenames, func, func_inputs)
      
      %   PARFOR_RUNNER -- Run `main_wrapper` in parallel for each file.
      
      N = numel( filenames );
      outs = cell( N, 1 );
      ids = shared_utils.io.filenames( filenames );
      longest_id_length = max( cellfun(@numel, ids) );
      
      parfor i = 1:numel(filenames)
        obj.print_progress( ids{i}, i, N, longest_id_length );
        
        outs{i} = obj.main_wrapper( filenames{i}, func, func_inputs );
      end
      
      outs = vertcat( outs{:} );
    end
    
    function outs = for_runner(obj, filenames, func, func_inputs)
      
      %   FOR_RUNNER -- Run `main_wrapper` for each file, serially.
      
      N = numel( filenames );
      outs = cell( N, 1 );
      ids = shared_utils.io.filenames( filenames );
      longest_id_length = max( cellfun(@numel, ids) );
      
      for i = 1:N
        obj.print_progress( ids{i}, i, N, longest_id_length );
        
        outs{i} = obj.main_wrapper( filenames{i}, func, func_inputs );
        
        if ( check_should_escape(obj) )
          break;
        end
      end
      
      outs = vertcat( outs{:} );
    end
    
    function validate_and_assign_func_handle(obj, func, val)
      validateattributes( val, {'function_handle'}, {}, func, func );
      obj.(func) = val;
    end
    
    function f = get_files_aggregate(obj)
      switch ( obj.files_aggregate_type )
        case 'struct'
          f = struct();
        case 'containers.Map'
          f = containers.Map();
        otherwise
          error( 'Unrecognized files_aggregate_type "%s".', obj.files_aggregate_type );
      end
    end
    
    function o = get_outputs_empty_inputs(obj)
      o = obj.get_default_output_status( '' );
      o = o(false);
    end
    
    function files = get_input_filenames(obj)
      if ( isempty(obj.input_directories) )
        files = {};
        return
      end
      
      first_input = obj.input_directories{1};
      files = obj.filter_files_func( obj.find_files_func(first_input) );
    end
    
    function handle_input_directories(obj)
      n_dirs = numel( obj.input_directories );
      
      if ( n_dirs == 0 )
        return;
      end
      
      obj.first_input_directory = obj.input_directories{1};
      
      if ( n_dirs > 1 )
        obj.remaining_input_directories = obj.input_directories(2:end);        
      end  
    end
    
    function status = assign_error_struct(obj, status, err, identifier)
      status.success = false;
      status.message = err.message;
      status.error_identifier = err.identifier;
      status.file_identifier = identifier;
    end
    
    function print_progress(obj, id, iter, N, longest_id_length)
      
      n_spaces = longest_id_length - numel( id );
      space_str = repmat( ' ', 1, n_spaces );
      
      if ( ~isempty(obj.func_name) )
        str = sprintf( '%s: %s %s(%d of %d)', obj.func_name, id ...
          , space_str, iter, N );
      else
        str = sprintf( '%s %s(%d of %d)', id, space_str, iter, N );
      end
      
      obj.log_message( str, 'progress' );      
    end
    
    function log_message(obj, message, level, add_new_line)
      
      if ( nargin < 4 )
        add_new_line = true;
      end
      
      if ( strcmp(obj.log_level, 'off') )
        return
      end
      
      if ( strcmp(obj.log_level, 'progress') && ~strcmp(level, 'progress') )
        return
      end
      
      if ( strcmp(level, 'warn') )
        warning( message );
      else
        if ( add_new_line )
          fprintf( '\n %s', message );
        else
          fprintf( '%s', message );
        end
      end
    end
  end
  
  methods (Access = public, Static = true)    
    function r = empty_results()
      
      %   EMPTY_RESULTS -- Get empty results struct.
      
      r = shared_utils.pipeline.LoopedMakeRunner.get_default_output_status( '' );
      r = r(false);
    end
    
    function n = get_directory_name(p)
      if ( ispc() )
        slash = '\';
      else
        slash = '/';
      end
      
      parts = strsplit( p, slash );
      n = parts{end};
    end
    
    function obj = make_non_saving_with_output()
      
      %   MAKE_NON_SAVING_WITH_OUTPUT
      %
      %     Create LoopedMakeRunner instance configured to store the output
      %     of all calls to its main function, but not save that output.
      %
      %     See also shared_utils.pipeline.LoopedMakeRunner
      
      obj = shared_utils.pipeline.LoopedMakeRunner;
      obj.convert_to_non_saving_with_output();
    end
    
  end
  
  methods (Access = private, Static = true)   
    function files = default_find_files_func(input_p)
      files = shared_utils.io.find( input_p, '.mat' );
    end
    
    function x = noop(x), end

    function id = default_get_identifier_func(x, filename)
      id = x.identifier;
    end
    
    function o = get_default_output_status(primary_input_filename)
      o = struct();
      o.success = true;
      o.message = '';
      o.error_identifier = '';
      o.file_identifier = '';
      o.primary_input_filename = primary_input_filename;
      o.output_filename = '';
      o.output = [];
      o.saved = false;
    end
  end
end