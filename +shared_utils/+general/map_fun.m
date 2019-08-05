function varargout = map_fun(fun, map, varargin)

%   MAP_FUN -- Apply function to values of map-like object.
%
%     shared_utils.general.map_fun( func, s ); where `s` is a scalar 
%     struct, calls function `func` once for each field of `s`, with the 
%     corresponding field-value as input.
%
%     shared_utils.general.map_func( func, obj ); where `obj` is a
%     containers.Map object, calls function `func` once for each key of
%     `obj`, with the corresponding key-value as input.
%
%     See also shared_utils.general.is_map_like,
%       shared_utils.general.map2struct, structfun

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