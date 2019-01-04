function req_write_text_file(filename, contents)

shared_utils.io.require_dir( fileparts(filename) );
shared_utils.io.write_text_file( filename, contents );

end