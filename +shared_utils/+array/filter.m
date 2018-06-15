function arr = filter(arr, func)

%   FILTER -- Retain elements at which filter function evaluates to true.
%
%     B = ... filter( A, func ); returns an array containing the elements
%     of `A` selected by the function `func`. `func` is a handle to a
%     function that accepts a single input and returns a logical value
%     (true or false)
%
%     EX //
%
%     a = rand( 1e4, 1 );
%
%     b = ... filter( a, @(x) x > 0.5 );
%
%     IN:
%       - `arr` (T)
%       - `func` (function_handle)
%     OUT:
%       - `arr` (T)

arr = arr( arrayfun(func, arr) );
end