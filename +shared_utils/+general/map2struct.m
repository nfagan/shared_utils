function b = map2struct(obj)

%   MAP2STRUCT -- Convert map-like object to struct.
%
%     b = shared_utils.general.map2struct( obj ); for the containers.Map
%     object `obj` returns a scalar struct `b` whose fields are the keys of
%     `obj`, set to corresponding values.
%
%     b = shared_utils.general.map2struct( s ); for the struct `s` returns
%     a copy of `s`.
%
%     b = shared_utils.general.map2struct( obj ); for the Matlab object
%     `obj` returns a scalar struct `b` whose fields are the public
%     properties of `obj`, set to corresponding values.
%
%     See also shared_utils.general.keys, shared_utils.general.is_map_like

if ( isa(obj, 'containers.Map') )
  k = keys( obj );
  b = struct();
  
  for i = 1:numel(k)
    b.(k{i}) = obj(k{i});
  end
elseif ( isstruct(obj) )
  b = obj;
elseif ( isobject(obj) )
  k = properties( obj );
  b = struct();
  
  for i = 1:numel(k)
    b.(k{i}) = obj.(k{i});
  end
else
  error( 'Unimplemented type "%s".', class(obj) );
end

end