function v = get(obj, str)

%   GET -- Get value from object, struct, or containers.Map object.
%
%     IN:
%       - `obj` (obj, struct, containers.Map)
%       - `str` (char)
%     OUT:
%       - `v` (/any/)

if ( isa(obj, 'containers.Map') )
  v = obj(str);
else
  v = obj.(str);
end

end