function [s, components] = nested_period_substruct(fieldname)

%   NESTED_PERIOD_SUBSTRUCT -- Make substruct of nested period subscripts.
%
%     s = shared_utils.general.nested_period_substruct( fieldname ); for
%     the possibly period-delimited char vector `fieldname` returns a
%     substruct `s` such that `subsref( some_struct, s )` returns the
%     possibly nested field of `some_struct`.
%
%     Ex //
%
%     X = struct( 'x', struct('y', 1) );
%     s = shared_utils.general.nested_period_substruct( 'x.y' );
%     v = subsref( X, s )
%
%     See also shared_utils.general.parsestruct, subsref, substruct

components = strsplit( fieldname, '.' );
periods = repmat( {'.'}, 1, numel(components) );

joined = cell( 1, numel(periods)*2 );
joined(1:2:end) = periods;
joined(2:2:end) = components;

s = substruct( joined{:} );

end