function idx = get_loop_indices(N)

%   GET_LOOP_INDICES -- Get loop indices for the current worker.
%
%     indices = ... get_loop_indices( N ); returns a subset of the array
%     [ 1:N ] divided maximally evenly between the current number of
%     workers. 
%
%     This function can be used to generate mutually exclusive
%     loop indices in an spmd block.
%
%     EX //
%
%     spmd
%       idx = shared_utils.parallel.get_loop_indices( 10 );
%
%       for i = idx
%         fprintf( '\n%d', i );
%       end
%     end
%
%     IN:
%       - `N` (numeric)
%     OUT:
%       - `idx` (double)

validateattributes( N, {'numeric'}, {'scalar'}, 'get_loop_indices', 'N' );
inds = shared_utils.vector.distribute( 1:N, numlabs );
idx = inds{labindex};

end