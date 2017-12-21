function parsed = cat_parse_double( cat_name, values )

import shared_utils.assertions.*;

assert__isa( cat_name, 'char', 'the category name' );
assert__is_cellstr_or_char( values, 'the category elements' );

values = shared_utils.cell.ensure_cell( values );

parsed = zeros( size(values) );

for i = 1:numel(values)
  assert( ~isempty(strfind(values{i}, cat_name)), ['The given label ''%s''' ...
    , ' does not contain the category name ''%s''.'], values{i}, cat_name );
  parse_err_msg = sprintf( 'Invalid format for label ''%s''.', values{i} );
  assert( numel(values{i}) > numel(cat_name), parse_err_msg );
  res = str2double( values{i}(numel(cat_name)+1:end) );
  assert( ~isnan(res), parse_err_msg );
  
  parsed(i) = res;
end

end