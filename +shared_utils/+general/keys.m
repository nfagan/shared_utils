function k = keys(obj)

%   KEYS -- Get keys of object, struct, or containers.Map object.
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