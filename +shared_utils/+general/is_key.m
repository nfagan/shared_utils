function tf = is_key(obj, k)

%   IS_KEY -- True if hash-map-like object contains key.
%
%     tf = ... is_key( CONTAINER, KEY ) returns true if the hash-map-like
%     container `CONTAINER` has a char vector key `KEY`. If `KEY` is a cell 
%     array of strings, `tf` is a logical array the same size as `KEY`.
%
%     In particular:
%
%     tf = ... is_key( S, KEY ) returns true if `KEY` is a field of struct
%     `S`.
%
%     tf = ... is_key( OBJ, KEY ) returns true if `KEY` is a property of
%     Matlab object `OBJ`.
%
%     tf = ... is_key( MAP, KEY ) returns true if `KEY` is a key of the
%     containers.Map object `KEY`.
%
%     In this way, is_key() provides a standardized interface for checking
%     the presence of a key in a hash-map-like object.
%
%     See also shared_utils.general.set, shared_utils.general.set,
%       shared_utils.general.keys
%
%     IN:
%       - `obj` (object, struct, containers.Map)
%     OUT:
%       - `tf` (logical)

if ( ischar(k) )
  tf = check_char( obj, k );
else
  tf = cellfun( @(x) check_char(obj, x), k );
end

end

function tf = check_char(obj, k)

if ( isa(obj, 'containers.Map') )
  tf = isKey( obj, k );
elseif ( isstruct(obj) )
  tf = isfield( obj, k );
elseif ( isobject(obj) )
  tf = any( strcmp(properties(obj), k) );
else
  error( 'Invalid container class: "%s".', class(obj) );
end

end