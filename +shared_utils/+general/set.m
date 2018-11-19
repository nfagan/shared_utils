function obj = set(obj, str, val)

%   SET -- Assign value to object, struct, or containers.Map object.
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