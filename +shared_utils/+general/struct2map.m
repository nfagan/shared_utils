function b = struct2map(obj, ensure_copy)

%   STRUCT2MAP -- Convert struct to containers.Map object.
%
%     b = shared_utils.general.struct2map( s ); for the struct `s` returns 
%     a containers.Map object `b` whose keys are the fields of `s`, set to 
%     corresponding values.
%
%     b = shared_utils.general.map2struct( obj ); for the containers.Map
%     object `obj`, returns `obj` in `b`. `b` is a handle to the same
%     object as `obj`, rather than a copy.
%
%     b = shared_utils.general.struct2map( obj ); for the Matlab object
%     `obj` returns a containers.Map object `b` whose keys are the public
%     properties of `obj`, set to corresponding values.
%
%     b = shared_utils.general.map2struct( obj, copy); indicates whether to
%     return a shallow-copy of `obj` in `b` in the event that `obj` is a
%     containers.Map object. Default is false;
%
%     See also shared_utils.general.keys, shared_utils.general.is_map_like

if ( nargin < 2 )
  ensure_copy = false;
else
  validateattributes( ensure_copy, {'logical'}, {'scalar'}, mfilename, 'ensure copy' );
end

if ( isa(obj, 'containers.Map') )
  if ( ensure_copy )
    b = containers.Map( 'keytype', obj.KeyType, 'valuetype', obj.ValueType );
    k = keys( obj );
    
    for i = 1:numel(k)
      b(k{i}) = obj(k{i});
    end
  else
    b = obj;
  end
  return;
end

if ( isstruct(obj) )
  fs = fieldnames( obj );
elseif ( isobject(obj) )
  fs = properties( obj );
else
  error( 'Unimplemented type "%s".', class(obj) );
end

b = containers.Map();

for i = 1:numel(fs)
  b(fs{i}) = obj.(fs{i});
end

end