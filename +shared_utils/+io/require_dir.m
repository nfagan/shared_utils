function require_dir(pathstr)

%   REQUIRE_DIR -- Create a folder if it does not already exist.
%
%     IN:
%       - `pathstr` (char) -- Path to the folder to create.

if ( iscellstr(pathstr) )
  for i = 1:numel(pathstr)
    shared_utils.io.require_dir(pathstr{i}); 
  end
  return;
end

shared_utils.assertions.assert__isa( pathstr, 'char', 'the path string' );
if ( exist(pathstr, 'dir') ~= 7 )
  try
    mkdir( pathstr );
  catch err
    fprintf( ['\nThe following error occurred when attempting to create' ...
      , ' ''%s'':'], pathstr );
    throw( err );
  end
end

end