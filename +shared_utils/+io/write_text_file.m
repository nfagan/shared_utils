function write_text_file(filename, contents)

validateattributes( filename, {'char'}, {'scalartext'}, mfilename, 'filename' );
validateattributes( contents, {'char'}, {'scalartext'}, mfilename, 'contents' );

filename = shared_utils.char.require_end( filename, '.txt' );

opened_file = false;
fid = nan;

try
  fid = fopen( filename, 'wt' );
  
  if ( fid == -1 )
    error( 'Failed to open file: "%s".', filename );
  end
  
  opened_file = true;
  
  fprintf( fid, '%s', contents );
catch err
  warning( err.message );
end

if ( opened_file )
  fclose( fid );
end

end