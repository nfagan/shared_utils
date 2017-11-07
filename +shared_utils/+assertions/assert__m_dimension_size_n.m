function assert__m_dimension_size_n(var, m, n, var_name)
      
%   ASSERT__M_DIMENSION_SIZE_N -- Ensure a variable is of a certain size in
%     a given dimension.
%
%     IN:
%       - `var` (/any/) -- Variable to check.
%       - `m` (double) -- Dimension.
%       - `n` (double) -- Expected number of elements in that dimension.
%       - `var_name` (char) |OPTIONAL| -- Optionally provide a more
%         descriptive name for the variable in case the assertion
%         fails.

if ( nargin < 4 ), var_name = 'input'; end
assert( size(var, m) == n ...
 , 'Expected dimension %d of %s to have %d elements; %d were present.' ...
  , m, var_name, n, size(var, m) );
end