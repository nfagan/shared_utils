function tf = is_field(s, name)

%   IS_FIELD -- True if field exists, evaluated recursively.
%
%     tf = shared_utils.struct.is_field( s, name ); for a char vector or
%     string scalar `name` that is a valid struct fieldname, is the same as
%     `isfield( s, name )`;
%
%     tf = shared_utils.struct.is_field( s, name ); where `name` has the
%     form 'a.b' for an arbitrary number of period-separated values,
%     returns true if 'a' is a field of `s`, and 'b' is a field of s.a,
%     and so on.
%
%     See also shared_utils.struct.field_or

name = strsplit( name, '.' );
tf = false;

for i = 1:numel(name)
  if ( isfield(s, name{i}) )
    s = s.(name{i});
  else
    return
  end
end

tf = true;

end