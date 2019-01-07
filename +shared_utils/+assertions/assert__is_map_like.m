function assert__is_map_like(var, var_name)

if ( nargin < 2 ), var_name = 'input'; end

assert( shared_utils.general.is_map_like(var) ...
  , 'Expected %s to a map-like object; was a ''%s''.' ...
  , var_name, class(var));

end