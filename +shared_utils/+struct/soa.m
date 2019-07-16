function s = soa(aos, fields, dim)

%   SOA -- Convert array-of-struct to struct-of-array.
%
%     s = shared_utils.struct.soa( aos ); converts the MxNxPx... struct
%     array `aos` to a scalar struct `s` with the same fields by
%     vertically-concatenating the values in `aos`.
%
%     s = shared_utils.struct.soa( aos, fields ); specifies a subset of
%     fields of `aos` to convert, and correspondingly the fields of `s`.
%
%     s = shared_utils.struct.soa( ..., dim ); concatenates fields across
%     `dim`, a positive integer scalar. Default is 1.
%
%     See also struct

validateattributes( aos, {'struct'}, {}, mfilename, 'array-of-struct' );

if ( nargin < 3 )
  dim = 1;
else
  validateattributes( dim, {'double', 'single'}, {'scalar', 'integer'} ...
    , mfilename, 'dimension' );
end

if ( nargin < 2 )
  fields = fieldnames( aos );
else
  fields = cellstr( fields );
  
  if ( ~isempty(fields) && ~all(isfield(aos, fields)) )
    non_existent = ~isfield( aos, fields );
    error( 'Reference to nonexistent field(s): "%s".' ...
      , strjoin(fields(non_existent)) );
  end
end

s = struct();

for i = 1:numel(fields)
  s.(fields{i}) = cat( dim, aos.(fields{i}) );
end

end