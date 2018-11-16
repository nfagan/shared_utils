classdef TextFieldDropdown < handle
  
  properties (Access = public)
    parent;
    convert_logical;
  end
  
  properties (SetAccess = public, GetAccess = private)
    on_change;
  end
  
  properties (GetAccess = public, SetAccess = private)
    data;
  end
  
  properties (Access = private)
    to_string_funcs;
    from_string_funcs;
    target;
    edit_panel;
    dropdown_panel;
    label_panel;
  end
  
  methods
    function obj = TextFieldDropdown()
      obj.data = struct();
      obj.to_string_funcs = struct();
      obj.from_string_funcs = struct();
      obj.parent = [];
      obj.convert_logical = true;
      
      obj.on_change = @(old_data, new_data, target) 1;
      
      obj.target = [];
      obj.edit_panel = [];
      obj.dropdown_panel = [];
      obj.label_panel = [];
    end
    
    function delete(obj)
      obj.conditional_delete_resource( obj.edit_panel );
      obj.conditional_delete_resource( obj.dropdown_panel );
      obj.conditional_delete_resource( obj.label_panel );
    end
    
    function set.on_change(obj, val)
      prop = 'on_change';
      validateattributes( val, {'function_handle'}, {}, prop, prop );
      obj.(prop) = val;
    end
    
    function set_data(obj, val)
      prop = 'data';
      validateattributes( val, {'struct'}, {'scalar'}, prop, prop );
      
      obj.data = val;
      obj.from_string_funcs = structfun( @(x) str2func(class(x)), val, 'un', 0 );
      obj.to_string_funcs = structfun( @(x) obj.get_to_string_func(x), val, 'un', 0 ); 
      
      obj.Update();
    end
    
    function set.parent(obj, val)
      prop = 'parent';
      
      allowed_classes = { 'matlab.ui.container.Panel', 'matlab.ui.Figure' };
      
      if ( isempty(val) )
        obj.parent = [];
        return
      else
        validateattributes( val, allowed_classes, {'scalar'}, prop, prop );
      end   
      
      obj.(prop) = val;
    end
    
    function set.convert_logical(obj, val)
      prop = 'convert_logical';
      validateattributes( val, {'logical', 'double'}, {'scalar'}, prop, prop );
      obj.(prop) = logical( val );
    end
  end
  
  methods (Access = public)
    function Update(obj)
      
      w = 0.5;
      l = 1;
      x = 0;
      y = 0;

      position = [ x, y, w, l ];

      dat = obj.data;
      strs = fieldnames( dat );

      if ( numel(strs) == 0 )
        return;
      end
      
      c_parent = obj.get_parent();

      if ( isempty(obj.target) || ~any(strcmp(strs, obj.target)) )
        obj.target = strs{1};
      end

      idx = find( strcmp(strs, obj.target) );
      
      if ( numel(idx) ~= 1 )
        warning( 'Expected 1 element to match "%s".', obj.target );
        return
      end
      
      current_str = strs{idx};
      
      val = dat.(current_str);
      convert_func = obj.to_string_funcs.(current_str);
      
      obj.conditional_delete_resource( obj.edit_panel );
      obj.conditional_delete_resource( obj.label_panel );

      if ( obj.is_editable_type(val) )
        obj.edit_panel = uicontrol( c_parent ...
          , 'Style',  'edit' ...
          , 'String',  convert_func(val) ...
          , 'Units',  'normalized' ...
          , 'Position', position ...
          , 'Callback', @handle_edit ...
        );
      else
        obj.label_panel = uicontrol( c_parent ...
          , 'Style', 'text' ...
          , 'String', sprintf('Values of class "%s" are not editable.', class(val)) ...
          , 'Units', 'normalized' ...
          , 'Position', position ...
        );
      end

      position = [ x+w, y, w, l ];
      
      obj.conditional_delete_resource( obj.dropdown_panel );
      
      obj.dropdown_panel = uicontrol( c_parent ...
        , 'Style',      'popup' ...
        , 'String',     strs ...
        , 'Value',      idx ...
        , 'Units',      'normalized' ...
        , 'Tag',        'timein_selector' ...
        , 'Position',   position ...
        , 'Callback',   @handle_select ...
      );

      function handle_select(source, event)
        obj.target = source.String{source.Value};
        obj.Update();
      end

      function handle_edit(source, event)
        targ = obj.target;
        
        try
          str = source.String;
          
          previous_value = obj.data.(targ);
          
          try 
            value = shared_utils.gui.TextFieldDropdown.isolated_eval( str );
          catch err
            warning( 'Failed to evaluate expression:\n\n %s\n', err.message );
            
            value = previous_value;
          end
          
          if ( ~obj.is_editable_type(value) )
            warning( ['Could not update "%s", because inputted value of class "%s"' ...
              , ' is not editable.'], targ, class(value) );
            
            value = previous_value;
          end
        catch err
          warning( err.message );
          return;
        end
        
        old_data = obj.data;
        new_data = old_data;
        new_data.(targ) = value;
        
        try
          obj.on_change( old_data, new_data, targ );
        catch err
          warning( err.message );
        end
        
        obj.set_data( new_data );
      end
    end
  end
  
  methods (Access = private)
    function p = get_parent(obj)
      if ( isempty(obj.parent) || ~isvalid(obj.parent) )
        p = figure(1);
      else
        p = obj.parent;
      end
    end
    
    function tf = is_editable_type(obj, v)      
      if ( isnumeric(v) || islogical(v) || ischar(v) )
        tf = true;
        return
      end
      
      if ( isstring(v) && numel(v) == 1 )
        tf = true;
        return
      end
            
      tf = false;
    end
    
    function conditional_delete_resource(obj, v)
      if ( ~isempty(v) ), delete( v ); end
    end
    
    function func = get_to_string_func(obj, v)
      if ( ischar(v) )
        func = @(x) obj.get_value_check_logical(x);
      elseif ( isnumeric(v) )
        func = @(x) mat2str(x, 'class');
      elseif ( islogical(v) )
        func = @(x) char(logical(x));
      else
        func = @char;
      end
    end
    
    function s = get_value_check_logical(obj, str)
      if ( ~obj.convert_logical )
        s = str;
        return
      end
      
      if ( strcmp(str, 'false') )
        s = false;
      elseif ( strcmp(str, 'true') )
        s = true;
      else
        s = str;
      end
    end
  end
  
  methods (Access = private, Static = true)
    function v = isolated_eval(str)
      v = eval( str );
    end
  end
  
end