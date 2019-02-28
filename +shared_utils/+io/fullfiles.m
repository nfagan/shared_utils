function ps = fullfiles(varargin)

%   FULLFILES -- Build full filenames from combinations of parts.
%
%     p = fullfiles( A, B, ... ) where any of `A`, `B`, ... are cell
%     arrays of strings, generates a cell array of absolute file paths in 
%     `p`. Each element of `p` is an absolute file path drawn from one 
%     combination of elements in cell arrays `A`, `B`, plus any character 
%     vector inputs.
%
%     p = fullfiles( A, B, ... ) where `A`, `B`, ... are all character
%     vectors, is the same as fullfile( A, B, ... ), except that output `p`
%     is contained in a cell.
%
%     EX //
%
%     p1 = fullfile( 'a', {'b', 'c'}, {'d', 'e'} )
%     p2 = shared_utils.io.fullfiles( 'a', {'b', 'c'}, {'d', 'e'} )
%
%     See also fullfile
%
%     IN:
%       - `varargin` (cell array of strings, char)
%     OUT:
%       - `ps` (cell array of strings)

narginchk( 1, Inf );

ind_chars = cellfun( @ischar, varargin );
ind_cellstrs = cellfun( @iscellstr, varargin );

N = numel( varargin );
n_chars = sum( ind_chars );
n_cells = sum( ind_cellstrs );

assert( n_chars + n_cells == N, 'Inputs must be cellstr or char.' );

if ( n_cells == 0 )
  ps = { fullfile( varargin{:} ) };
  return;
end

cellstrs = varargin( ind_cellstrs );
ns = cellfun( @numel, cellstrs );
index_vecs = arrayfun( @(x) 1:x, ns, 'un', 0 );

inds = combvec( index_vecs{:} );
n_inds = size( inds, 2 );
vals = cell( 1, n_cells );

full_set = varargin;
ps = cell( n_inds, 1 );

for i = 1:n_inds
  current = inds(:, i);
  
  for j = 1:n_cells
    vals{j} = cellstrs{j}{current(j)};
  end
  
  full_set(ind_cellstrs) = vals;
  
  ps{i} = fullfile( full_set{:} );
end

end