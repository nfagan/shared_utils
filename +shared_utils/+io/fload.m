function out = fload(fname, varname)

%   FLOAD -- Load in and assign to variable.
%
%     out = ... fload( 'file1.mat' ); loads the contents of 'file1.mat' and
%     assigns to the variable `out`. 'file1.mat' cannot contain multiple 
%     variables.
%
%     out = ... fload( ..., VARNAME ); loads the variable `VARNAME` and
%     assigns to the variable `out`. `VARNAME` must be a variable contained
%     in the file.
%
%     IN:
%       - `fname` (char) -- .mat file to load.
%       - `varname` (char) |OPTIONAL|
%     OUT:
%       - `out` (/any/) -- Loaded data.

import shared_utils.assertions.*;

assert__isa( fname, 'char', 'the .mat file' );
assert__file_exists( fname, 'the .mat file' );

var = load( fname );
fs = fieldnames( var );

if ( nargin == 1 )
  assert( numel(fs) == 1, 'More than one variable saved in ''%s''.', fname );
  out = var.(fs{1});
else
  assert__isa( varname, 'char', 'the variable name' );
  assert( isfield(var, varname), 'Variable "%s" does not exist.', varname );
  out = var.(varname);
end

end