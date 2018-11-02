function obj = parseobject(obj, args)

%   PARSEOBJECT -- Assign variable inputs to object.
%
%     See also shared_utils.general.parsestruct
%     
%     IN:
%       - `params` (struct)
%       - `args` (cell)
%     OUT:
%       - `params` (struct)

assert( isobject(obj) && isscalar(obj), '"params" must be a scalar Matlab object.' );
validateattributes( args, {'cell'}, {}, 'parsestruct', 'args' );

try 
  args = merge_struct_cell( args );
catch err
  throw( err );
end

N = numel( args );

props = properties( obj );

for i = 1:2:N
  name = args{i};
  
  if ( any(strcmp(props, name)) )
    obj.(name) = args{i+1};
  else
    error( '"%s" is not a recognized property.', name );
  end
end

end

function s = merge_struct_cell(args)

N = numel( args );
stp = 1;

s = {};

while ( stp <= N )
  v = args{stp};
  
  if ( ischar(v) )
    assert( stp + 1 <= N, '"name", value pairs are incomplete.' );
    
    s = [ s, args(stp), args(stp+1) ];
    stp = stp + 2;
    
  elseif ( iscell(v) )
    s = [ s, merge_struct_cell(v) ];
    stp = stp + 1;
    
  else
    assert( isstruct(args{stp}), ['Inputs must come in "name", value pairs' ...
      , ', or else be struct.'] );
    
    s = [ s, shared_utils.general.struct2varargin(v) ];
    stp = stp + 1;
  end
end


end