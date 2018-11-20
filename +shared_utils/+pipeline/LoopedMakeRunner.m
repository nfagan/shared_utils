classdef LoopedMakeRunner < handle
  
  properties (Access = public)
    log_level = 'info';
    func_name = '';
    
    files_aggregate_type = 'struct';
    
    input_directories = {};
    output_directory = '';
    
    is_parallel = true;
    overwrite = false;
    save = true;
    call_with_identifier = false;
    
    load_func = @shared_utils.io.fload;
    save_func = @shared_utils.io.psave;
    get_identifier_func = @shared_utils.pipeline.LoopedMakeRunner.default_get_identifier_func;
    get_filename_func = @shared_utils.pipeline.LoopedMakeRunner.noop;
    filter_files_func = @shared_utils.pipeline.LoopedMakeRunner.noop;
    find_files_func = @shared_utils.pipeline.LoopedMakeRunner.default_find_files_func;
    get_directory_name_func = @shared_utils.pipeline.LoopedMakeRunner.get_directory_name;
  end
  
  properties (Access = private)
    first_input_directory = '';
    remaining_input_directories = {};
  end
  
  properties (Access = private, Constant = true)
    log_levels = { 'info', 'warn', 'progress', 'off' };
    files_aggregate_types = { 'struct', 'containers.Map' };
  end
  
  methods    
    function obj = LoopedMakeRunner(varargin)
      try
        shared_utils.general.parseobject( obj, varargin );
      catch err
        throw( err );
      end
    end
    
    function res = run(obj, func, varargin)
      
      %   RUN -- Run make* function.
      %
      %     res = obj.run( func ); calls the function `func` with input
      %     `files`, where `files` is a struct with a field for each
      %     directory in `obj.input_directories`, separately for each
      %     unique filename obtained from `obj.find_files_func`.
      %     
      %     Output `res` is an array of struct indicating the status of
      %     processing each unique file. `res` has fields 'success', 
      %     'message', 'error_identifier', 'file_identifier',
      %     'primary_input_filename', 'output_filename', and 'saved'.
      %
      %     IN:
      %       - `func` (function_handle)
      %       - `varargin` (/any/)
      %     OUT:
      %       - `res` (struct)
      
      validateattributes( func, {'function_handle'}, {}, 'run', 'func' );
      
      obj.handle_input_directories();

      try
        input_filenames = obj.get_input_filenames();
      catch err
        throw( err );
      end
      
      if ( isempty(input_filenames) )
        res = obj.get_outputs_empty_inputs();
        return
      end
      
      if ( obj.use_parallel() )
        res = obj.parfor_runner(input_filenames, func, varargin);
      else
        res = obj.for_runner(input_filenames, func, varargin);
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
  end
  
  methods (Access = private)
    
    function tf = use_parallel(obj)
      tf = obj.is_parallel && ~isempty( gcp('nocreate') );
    end
    
    function full_filename = get_output_file_parts(obj, identifier)
      full_filename = fullfile( obj.output_directory, identifier );
    end
    
    function should_skip = conditional_skip_file(obj, output_filename, identifier)
      should_skip = shared_utils.io.fexists( output_filename ) && ~obj.overwrite;
      
      if ( should_skip )
        msg = sprintf( 'Skipping "%s" because it already exists.', identifier );
        obj.log_message( msg, 'info' );
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
    
    function res = main_wrapper(obj, filename, func, func_inputs)
      
      %   MAIN_WRAPPER -- Call make* function for one file identifier.
      %
      %     This is the main routine.
      
      res = obj.get_default_output_status( filename );
      
      identifier = '';
      
      try
        % try to load the primary file -- the file from which the
        % identifier will be derived.
        
        [primary_file, identifier] = obj.get_primary_file( filename );
        
      catch err
        obj.log_message( err.message, 'warn' );
        
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
        obj.log_message( err.message, 'warn' );
        
        res = obj.assign_error_struct( res, err, identifier );
        return
      end
      
      try
        % call the function `func` with `files` and `func_inputs`. `func`
        % should return one output, which will be conditionally saved in 
        % the directory given by `obj.output_directory`, depending on the
        % state of `obj.overwrite` and `obj.save`.
        
        if ( obj.call_with_identifier )
          out_file = func( files, identifier, func_inputs{:} );
        else
          out_file = func( files, func_inputs{:} );
        end
      
        if ( obj.save )
          shared_utils.io.require_dir( obj.output_directory );
          obj.save_func( output_filename, out_file );
          
          res.saved = true;
        end
      catch err
        obj.log_message( err.message, 'warn' );
        
        res = obj.assign_error_struct( res, err, identifier );
      end
    end
    
    function outs = parfor_runner(obj, filenames, func, func_inputs)
      
      %   PARFOR_RUNNER -- Run `main_wrapper` in parallel for each file.
      
      name = obj.func_name;
      outs = cell( numel(filenames), 1 );
      
      parfor i = 1:numel(filenames)
        obj.log_message( sprintf('%s: %d of %d', name, i, numel(filenames)), 'progress' );
        
        outs{i} = obj.main_wrapper( filenames{i}, func, func_inputs );
      end
      
      outs = vertcat( outs{:} );
    end
    
    function outs = for_runner(obj, filenames, func, func_inputs)
      
      %   FOR_RUNNER -- Run `main_wrapper` for each file, serially.
      
      name = obj.func_name;
      outs = cell( numel(filenames), 1 );
      
      for i = 1:numel(filenames)
        obj.log_message( sprintf('%s: %d of %d', name, i, numel(filenames)), 'progress' );
        
        outs{i} = obj.main_wrapper( filenames{i}, func, func_inputs );
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
    
    function log_message(obj, message, level)
      
      if ( strcmp(obj.log_level, 'off') )
        return
      end
      
      if ( strcmp(obj.log_level, 'progress') && ~strcmp(level, 'progress') )
        return
      end
      
      if ( strcmp(level, 'warn') )
        warning( message );
      else
        fprintf( '\n %s', message );
      end
    end
  end
  
  methods (Access = public, Static = true)
    
    function n = get_directory_name(p)
      if ( ispc() )
        slash = '\';
      else
        slash = '/';
      end
      
      parts = strsplit( p, slash );
      n = parts{end};
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
      o.saved = false;
    end
  end
end