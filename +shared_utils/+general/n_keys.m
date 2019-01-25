function n = n_keys(obj)

%   N_KEYS -- Count number of keys in map-like object.
%
%     N = ... n_keys( S ); where `S` is a scalar struct, returns the number
%     of fields of `S`.
%
%     N = ... n_keys( MAP ); where `MAP` is a containers.Map object,
%     returns then number of key-value pairs in `MAP`.
%
%     N = ... n_keys( OBJ ); where `OBJ` is a Matlab object, returns the
%     number of public properties in `OBJ`.

if ( isa(obj, 'containers.Map') )
  n = obj.Count;
elseif ( isstruct(obj) )
  n = numel( fieldnames(obj) );
else
  n = numel( properties(obj) );
end

end