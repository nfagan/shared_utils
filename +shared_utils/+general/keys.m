function k = keys(obj)

%   KEYS -- Get keys of object, struct, or containers.Map object.
%
%     See also shared_utils.general.is_key, shared_utils.general.set
%
%     IN:
%       - `obj` (object, struct, containers.Map)
%     OUT:
%       - `k` (cell array of strings)

if ( isa(obj, 'containers.Map') )
  k = keys( obj );
elseif ( isstruct(obj) )
  k = fieldnames( obj );
else
  k = properties( obj );
end

end