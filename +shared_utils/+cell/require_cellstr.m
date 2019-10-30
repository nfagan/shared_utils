function [elements, is_missing] = require_cellstr(elements)

%   REQUIRE_CELLSTR -- Convert to cell array of strings, replacing non-char
%     elements with the empty char ('').
%
%     out_values = shared_utils.cell.require_cellstr( values ); replaces
%     non-char entries in the cell array `values` with the empty char (''),
%     so that `out_values` is a cell array of strings.
%
%     out_values = shared_utils.cell.require_cellstr( value ); for the char
%     array `value` returns a scalar cell array of strings containing
%     `value`.
%
%     out_values = shared_utils.cell.require_cellstr( values ); for an array
%     of any other class, returns a cell array of empty char ('') the same
%     size as `values`.
%
%     [..., is_missing] = shared_utils.xls.require_cellstr( values ); also
%     returns `is_missing`, an index of the non-char elements of `values`.
%
%     See also shared_utils.cell.ensure_cell

if ( ischar(elements) )
  elements = { elements };
  is_missing = false;
  
elseif ( ~iscell(elements) )
  elements = arrayfun( @(x) '', elements, 'un', 0 );
  is_missing = true( size(elements) );
  
else
  is_missing = cellfun(@(x) ~ischar(x), elements);
  elements(is_missing) = {''};
end

end