function out = percell(func, varargin)

%   PERCELL -- Execute a function cell-wise and return cell.
%
%     IN:
%       - `func` (function_handle)
%       - `varargin` (any)
%     OUT:
%       - `out` (cell)

out = cellfun( func, varargin{:}, 'un', false );

end