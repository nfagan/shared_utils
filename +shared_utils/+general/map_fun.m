function varargout = map_fun(fun, map, varargin)

%   MAP_FUN -- Apply function to values of map-like object.
%
%     ... map_fun( FUNC, S ); where `S` is a scalar struct, calls function 
%     `FUNC` once for each field of `S`, with the corresponding field-value
%     as input.
%
%     ... map_fun
%
%     See also shared_utils.general.is_map_like, structfun

shared_utils.assertions.assert__is_map_like( map );

if ( isa(map, 'containers.Map') )
  try
    [varargout{1:nargout}] = cellfun( @(x) fun(map(x)), keys(map), varargin{:} );
  catch err
    throw( err );
  end
  
elseif ( isstruct(map) || isobject(map) )
  [varargout{1:nargout}] = structfun( fun, map, varargin{:} );

else
  error( 'Unimplemented type: "%s".', class(map) );
end

end