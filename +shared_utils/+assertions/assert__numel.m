function assert__numel(var, N, var_name)
      
%   ASSERT__NUMEL -- Ensure a variable has a certain number of elements.
%
%     IN:
%       - `var` (/any/) -- Variable to check.
%       - `N` (double) -- Expected number of elements.
%       - `var_name` (char) |OPTIONAL| -- Optionally provide a more
%         descriptive name for the variable in case the assertion
%         fails.

if ( nargin < 3 ), var_name = 'input'; end
assert( numel(var) == N, 'Expected %s to have %d elements; %d were present.' ...
  , var_name, N, numel(var) );
end