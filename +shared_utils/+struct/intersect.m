function s1 = intersect(s1, s2)

%   INTERSECT -- Remove non-shared fields.
%
%     s3 = shared_utils.struct.intersect( s1, s2 ) removes from s1 fields
%     that are not shared between s1 and s2.
%
%     See also struct, shared_utils.struct.union

s1_fields = fieldnames( s1 );
shared_fields = intersect( s1_fields, fieldnames(s2) );
s1 = rmfield( s1, setdiff(s1_fields, shared_fields) );

end