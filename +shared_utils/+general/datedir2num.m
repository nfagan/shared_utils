function nums = datedir2num(datedirs, prefix)

% DATEDIR2NUM -- Convert date directory string to number.
%
%   nums = shared_utils.general.datedir2num( '03042019' ); return 737488,
%   the datenum representation of March-04-2019.
%
%   nums = shared_utils.general.datedir2num( C ); where `C` is a cell array
%   of datedir strings as above, returns an array of datenums the same size
%   as `C`.
%
%   nums = shared_utils.general.datedir2num( ..., PREFIX ); strips `PREFIX`
%   from each datedir string before performing the conversion.
%
%   This function throws an error if the datedir string does not match the
%   date format 'MMddyyyy', where M is month, d is day, and y is year.
%
%   See also datenum, datetime.

if ( nargin < 2 )
  to_convert = datedirs;
else
  to_convert = cellfun( @(x) x(numel(prefix)+1:end), datedirs, 'un', 0 );
end

nums = datenum( datetime(to_convert, 'format', 'MMddyyyy') );

end