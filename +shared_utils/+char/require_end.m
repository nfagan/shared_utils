function s = require_end(s, ext)

%   REQUIRE_END -- Add to string if it does not already end with value.
%
%     s = ... require_end( s, '.mat' ) adds '.mat' to the end of `s` if `s`
%     does not already end with '.mat'.
%
%     IN:
%       - `s` (char)
%       - `ext` (char)
%     OUT:
%       - `s` (char)

if ( ~shared_utils.char.ends_with(s, ext) )
  s = sprintf( '%s%s', s, ext );
end

end