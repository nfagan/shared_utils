function tf = is_map_like(obj)

%   IS_MAP_LIKE -- True if input is hash-map-like object.
%
%     tf = ... is_map_like( X ) returns true if `X` is a) a containers.Map
%     object b) a scalar struct or c) a scalar Matlab object, and false
%     otherwise.
%
%     See also shared_utils.general.get, shared_utils.general.keys
%
%     IN:
%       - `obj` (/any/)
%     OUT:
%       - `tf` (logical)

is_valid_struct_or_object = @(x) isscalar(x) && (isstruct(x) || isobject(x));
tf = isa( obj, 'containers.Map' ) || is_valid_struct_or_object( obj );

end