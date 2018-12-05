function fname = get_next_numbered_filename(p, ext)

%   GET_NEXT_NUMBERED_FILENAME
%
%     filename = ... get_next_numbered_filename( p, extension )
%     obtains a `filename` of the form <number>.<extension>, where <number> 
%     is the next in the linear sequence of numbers already present in the
%     directory `p`. If the directory does not exist, or no files with such 
%     a pattern exist, the filename will be 1.<extension>.
%
%     See also shared_utils.io.find, shared_utils.io.dirnames
%
%     IN:
%       - `p` (char)
%       - `ext` (char)
%     OUT:
%       - `fname` (char)

text_classes = { 'char' };
text_attrs = { 'scalartext' };

validateattributes( p, text_classes, text_attrs, mfilename, 'p' );
validateattributes( ext, text_classes, text_attrs, mfilename, 'ext' );

ext = require_dot( ext );

if ( ~shared_utils.io.dexists(p) )
  fname = make_filename( 1, ext );
  return
end

files = shared_utils.io.dirnames( p, ext );
names = shared_utils.io.filenames( files );

values = str2double( names );
values(isnan(values)) = [];

if ( isempty(values) )
  fname = make_filename( 1, ext );
else
  c_max = max( values );
  fname = make_filename( c_max+1, ext );
end

end

function fname = make_filename(number, ext)

fname = sprintf( '%d%s', number, ext );

end

function ext = require_dot(ext)

if ( isempty(ext) )
  return;
end

if ( ext(1) ~= '.' )
  ext = [ '.', ext ];
end

end