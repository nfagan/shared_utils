classdef MatrixLayout < handle  
  properties (GetAccess = public, SetAccess = private)
    rows;
    columns;
    contents;
    panel;
    parent;
    row_span;
    col_span;
  end
  
  properties (Access = private)
    next_assign_index;
  end
  
  methods
    function obj = MatrixLayout(rows, cols, parent)
      import shared_utils.gui.MatrixLayout;
      
      if ( nargin < 3 )
        parent = MatrixLayout.empty();
      end
      
      if ( nargin < 2 )
        cols = 1;
      end
      
      if ( nargin < 1 )
        rows = 1;
      end
      
      MatrixLayout.require_figure();
      MatrixLayout.validate_size_or_index( rows, inf, 'rows' );
      MatrixLayout.validate_size_or_index( cols, inf, 'columns' );
      
      obj.parent = parent;
      obj.rows = rows;
      obj.columns = cols;
      obj.contents = cell( rows, cols );
      obj.panel = MatrixLayout.make_initial_panel();
      obj.row_span = [];
      obj.col_span = [];
      obj.next_assign_index = 1;
    end
    
    function m = make_column(obj, j, varargin)
      import shared_utils.gui.MatrixLayout;
      
      MatrixLayout.validate_size_or_index( j, obj.columns, 'column index' );
      m = MatrixLayout( varargin{:} );
      
      obj.assign( 1:obj.rows, j, m );            
    end
    
    function show(obj)
      obj.panel.Visible = 'on';
    end
    
    function p = position(obj)
      if ( isempty(obj.parent) )
        p = [0, 0, 1, 1];
        
      else
        r = rect( obj ) - 1;
        s = size( obj.parent.contents );
        
        x0 = r(1) / s(2);
        y0 = r(2) / s(1);
        w = (r(3) - r(1)) / s(2);
        h = (r(4) - r(2)) / s(1);
        
        p = [ x0, y0, w, h ];  
      end
    end
    
    function r = rect(obj)
      if ( isempty(obj.parent) )
        r = zeros( 1, 4 );
        
      else
        x1 = obj.col_span(1);
        x2 = obj.col_span(end) + 1;
        y1 = obj.row_span(1);
        y2 = obj.row_span(end) + 1;
        
        r = [ x1, y1, x2, y2 ];
      end
    end
    
    function deparent(obj)
      p = obj.parent;
      
      if ( ~isempty(p) )
        child_ind = cellfun( @(x) ~isempty(x) && x == obj, p.contents );

        obj.parent = shared_utils.gui.MatrixLayout.empty();
        obj.panel.Parent = [];
        
        obj.row_span = [];
        obj.col_span = [];
        
        p.contents(child_ind) = { [] };
      end
    end
    
    function push(obj, child)
      if ( obj.next_assign_index > numel(obj.contents) )
        error( 'Attempt to push beyond maximum capacity: %d.', numel(obj.contents) );
      end
      
      [i, j] = ind2sub( size(obj.contents), obj.next_assign_index );
      assign( obj, i, j, child );
      obj.next_assign_index = obj.next_assign_index + 1;
    end
    
    function assign(obj, i, j, child)
      import shared_utils.gui.*;
      
      if ( nargin == 3 && isvector(obj.contents) )
        s = size( obj.contents );
        child = j;
        
        if ( s(1) == 1 )
          j = i;
          i = 1;
        else
          j = 1;
        end
      end
      
      MatrixLayout.validate_span( i, obj.rows, 'row index' );
      MatrixLayout.validate_span( j, obj.columns, 'column index' );
      MatrixLayout.validate_scalar_matrix_layout( child );
      
      if ( ~isempty(child.parent) )
        error( ['The target was already parented. Call `deparent` to explicitly' ...
          , ' remove its parent.'] );
      end
      
      check_self_reference( child, obj );
      
      MatrixLayout.deparent_many( obj.contents(i, j) );
      
      obj.contents(i, j) = { child };
      child.parent = obj;
      child.panel.Parent = obj.panel;
      child.row_span = i;
      child.col_span = j;
      
      position_panel( child );
    end
    
    function set.parent(obj, parent)
      classes = { 'shared_utils.gui.MatrixLayout' };
      prop_name = 'parent';
      
      validateattributes( parent, classes, {}, mfilename, prop_name );
      
      if ( ~isempty(parent) )
        validateattributes( parent, classes, {'scalar'}, mfilename, prop_name );
        check_self_reference( obj, parent );
      end
      
      obj.parent = parent;
    end
  end
  
  methods (Access = private)    
    function position_panel(obj)
      obj.panel.Position = position( obj );
    end
    
    function check_self_reference(obj, new_parent)
      p = new_parent;
      
      while ( ~isempty(p) )
        if ( obj == p )
          error( 'Setting this object as a parent would create a cyclic reference.' );
        end
        
        p = p.parent;
      end
    end
  end
  
  methods (Access = private, Static = true)
    function p = make_initial_panel()
      p = uipanel( ...
        'Visible', 'on' ...
        , 'Units', 'normalized' ...
        , 'Position', [0, 0, 1, 1] ...
      );
    end
    
    function deparent_many(contents)
      for i = 1:numel(contents)
        if ( ~isempty(contents{i}) )
          deparent( contents{i} );
        end
      end
    end
    
    function require_figure()
      f = get( 0, 'CurrentFigure' );
      
      if ( isempty(f) )
        figure( 'Visible', 'off' );
      end
    end
    
    function validate_scalar_matrix_layout(layout)
      validateattributes( layout, {'shared_utils.gui.MatrixLayout'} ...
        , {'scalar'}, mfilename, 'layout' );
    end
    
    function validate_span(s, max, name)
      classes = { 'numeric' };
      attrs = { 'integer', 'nonnan', 'finite', 'positive' };
      validateattributes( s, classes, attrs, mfilename, name );
      
      if ( any(s > max) )
        error( '"%s" must be <= %d.', name, max );
      end
      
      if ( ~issorted(s, 'strictascend') )
        error( '"%s" must specify a strictly ascending sorted slice.' );
      end
    end
    
    function validate_size_or_index(s, max, name)
      classes = { 'numeric' };
      attrs = { 'scalar', 'integer', 'nonnan', 'finite', 'positive' };
      validateattributes( s, classes, attrs, mfilename, name );
      
      if ( s > max )
        error( '"%s" must be <= %d.', name, max );
      end
    end
  end
end