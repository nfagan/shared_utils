function obj = set(obj, str, val)

%   SET -- Assign value to object, struct, or containers.Map object.
%
%     Y = shared_utils.general.set( X, key, value ) assigns `value` to `X`
%     at `key`, and returns the updated object as `Y`. This function 
%     provides a standardized interface for setting the contents of a 
%     containers.Map, struct, or Matlab object.
%
%     See also shared_utils.general.get
%
%     IN:
%       - `obj` (object, struct, containers.Map)
%       - `str` (char)
%       - `val` (/any/)
%     OUT:
%       - `obj` (object, struct, containers.Map)

if ( isa(obj, 'containers.Map') )
  obj(str) = val;
else
  obj.(str) = val;
end

end