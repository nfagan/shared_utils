function v = get(obj, str)

%   GET -- Get value from object, struct, or containers.Map object.
%
%     v = shared_utils.general.get( X, key ) returns the value in `X`
%     identified by the char vector `key`. This function provides a
%     standardized interface for accessing the contents of a containers.Map, 
%     struct, or Matlab object.
%
%     See also shared_utils.general.set

if ( isa(obj, 'containers.Map') )
  v = obj(str);
else
  v = obj.(str);
end

end