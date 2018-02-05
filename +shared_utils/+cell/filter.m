function arr = filter(test_func, arr)

%   FILTER -- Keep cell elements for which `test_func` returns true.
%
%     IN:
%       - `test_func` (function_handle)
%       - `arr` (cell array)
%     OUT:
%       - `arr` (cell array)

ind = cellfun( test_func, arr );
arr = arr( ind );

end