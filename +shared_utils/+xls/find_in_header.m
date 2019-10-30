function [inds, was_found] = find_in_header(entries, header, varargin)

%   FIND_IN_HEADER -- Find entries in header.
%
%     inds = shared_utils.xls.find_in_header( entries, header ); returns
%     an array the same size as `entries` containing the linear index of
%     each of `entries` in `header`. Entries not present are assigned the
%     index 0. `entries` and `header` can be cell arrays of strings or
%     char.
%
%     inds = shared_utils.xls.find_in_header( ..., 'error_on_not_found', true );
%     throws an error if any of `entries` are not present in `header`.
%
%     inds = shared_utils.xls.find_in_header( ..., 'exact_match', false );
%     performs a case-insentivie substring search to locate an element of
%     `entries` in `header`. If a lower-case element of `entries` is a
%     substring of an element of `header`, then a match is found for that
%     element.
%
%     [..., was_found] = shared_utils.xls.find_in_header(...) also returns
%     a logical array the same size as `entries` indicating whether each
%     element of `entries` was found in `header`.
%
%     See also shared_utils.cell.require_cellstr

if ( nargin < 3 )
  error_on_not_found = false;
  exact_match = true;
else
  defaults = struct();
  defaults.error_on_not_found = false;
  defaults.exact_match = true;
  
  params = shared_utils.general.parsestruct( defaults, varargin );
  
  error_on_not_found = params.error_on_not_found;
  exact_match = params.exact_match;
end

if ( exact_match )
  [was_found, inds] = ismember( entries, cellstr(header) );
else
  [was_found, inds] = inexact_match( cellstr(entries), cellstr(header) );
end

if ( error_on_not_found && ~all(was_found) )
  entries = cellstr( entries );
  error( 'Missing required header entries: "%s".' ...
    , strjoin(entries(~was_found), ' | ') );
end

end

function [was_found, inds] = inexact_match(entries, header)

was_found = false( size(entries) );
inds = zeros( size(entries) );

for i = 1:numel(entries)
  ind = find( cellfun(@(x) ~isempty(strfind(lower(x), lower(entries{i}))), header), 1 );
  
  if ( ~isempty(ind) )
    inds(i) = ind;
    was_found(i) = true;
  end
end

end