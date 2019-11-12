function v = field_or(s, field, val)

%   FIELD_OR -- Get field or default value from scalar struct.
%
%     v = shared_utils.struct.field_or( s, field, value ) returns `s.(field)`
%     if `field` is a field of `s`, or else `value`.

v = val;
if ( isfield(s, field) ), v = s.(field); end

end