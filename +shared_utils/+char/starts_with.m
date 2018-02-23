function tf = starts_with(a, b)

%   STARTS_WITH -- Return whether char `a` starts with char `b`
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

sub_str = a(1:numel(b));

tf = strcmp( sub_str, b );

end