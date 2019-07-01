function s1 = union(s1, s2)

%   UNION -- Combine structs.
%
%     s3 = shared_utils.struct.union( s1, s2 ) returns a struct containing
%     the fields of `s1` and `s2`. Fields shared between `s1` and `s2` have
%     values drawn from `s1`; fields unique to `s2` have values drawn from
%     `s2`. 
%
%     `s1` and `s2` need have compatible sizes. If `s1` and `s2` do not
%     have the same size, then `s2` must be scalar.
%
%     See also struct, shared_utils.struct.intersect

missing_fields = setdiff( fieldnames(s2), fieldnames(s1) );

for i = 1:numel(missing_fields)
  [s1(:).(missing_fields{i})] = deal( s2.(missing_fields{i}) );
end

end