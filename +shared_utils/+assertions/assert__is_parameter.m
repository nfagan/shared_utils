function assert__is_parameter(param, names, variable_name)

if ( nargin < 3 )
  variable_name = 'parameter';
end

validateattributes( param, {'char'}, {}, mfilename, 'parameter name' );
validateattributes( variable_name, {'char'}, {}, mfilename, 'variable name' );

names = cellstr( names );

assert( ismember(param, names) ...
  , 'Reference to non-existent %s: %s; options are: \n\n - %s' ...
  , variable_name, param, strjoin(names, '\n - ') );

end