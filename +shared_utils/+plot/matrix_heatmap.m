function ax = matrix_heatmap(ax_or_mat, mat)

if ( nargin == 1 )
  assert( isa(ax_or_mat, 'double'), 'If first input is axes, must supply matrix.' );
  
  mat = ax_or_mat;
  ax = gca;
else
  validateattributes( ax_or_mat, {'axes'}, {'scalar'}, mfilename, 'axes' );
  validateattributes( mat, {'double'}, {'matrix'}, filename, 'axes' );
  
  ax = ax_or_mat;
end

y_vec = 1:size(mat, 1);
y_mat = repmat( y_vec(:), 1, size(mat, 2) );

h = imagesc( ax, y_mat, 'CData', mat );

end