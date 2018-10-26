function fs = filenames(p, include_ext)

%   FILENAMES -- Get filenames from path string.
%
%     fs = ... filenames( p ); returns the filename component(s) of `p`.
%     `fs` is char is `p` is char, otherwise `fs` is cellstr.
%
%     fs = ... filenames( p, true ); includes the extension in each element
%     of `fs`.
%
%     See also fileparts
%
%     IN:
%       - `p` (cell array of strings, char)
%       - `include_ext` (logical) |OPTIONAL|
%     OUT:
%       - `fs` (cell array of strings, char)

if ( nargin < 2 ), include_ext = false; end

if ( ischar(p) )
  fs = filename( p, include_ext );
else
  fs = cellfun( @(x) filename(x, include_ext), p, 'un', 0 );
end

end

function y = filename(x, include_ext)
[~, name, ext] = fileparts( x );

if ( include_ext )
  y = [ name, ext ];
else
  y = name;
end

end