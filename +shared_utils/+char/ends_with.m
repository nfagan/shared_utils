function tf = ends_with(a, b)

%   ENDS_WITH -- Return whether char `a` ends with char `b`
%
%     IN:
%       - `a` (char)
%       - `b` (char)
%     OUT:
%       - `tf` (logical)

import shared_utils.assertions.*;

assert__isa( a, 'char' );
assert__isa( b, 'char' );

tf = false;

if ( numel(b) > numel(a) )
  return;
end

sub_str = a(end-numel(b)+1:end);

tf = strcmp( sub_str, b );

end