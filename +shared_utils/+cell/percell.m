function out = percell(func, varargin)

%   PERCELL -- Execute a function cell-wise and return cell.
%
%     z = ... percell( FUNC, X ) is equivalent to 
%     z = cellfun( FUNC, X, 'un', false ).
%
%     IN:
%       - `func` (function_handle)
%       - `varargin` (any)
%     OUT:
%       - `out` (cell)

out = cellfun( func, varargin{:}, 'un', false );

end