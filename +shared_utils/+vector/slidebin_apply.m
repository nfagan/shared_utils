function b = slidebin_apply(func, a, win, step, discard_uneven, uniform_output)

%   SLIDEBIN_APPLY -- Apply function to binned elements of vector.
%
%     B = shared_utils.vector.slidebin_apply( FUNC, A, WIN, STEP ) applies 
%     `FUNC` to subsets of `A` of mostly size `WIN`, stepped by `STEP`. The 
%     last bin of `A` may be smaller than size `WIN`. Each application of 
%     `FUNC` must return a scalar value of the same class, and the result 
%     will be concatenated into `B`.
%
%     B = shared_utils.vector.slidebin( A, W ) uses `W` for both window and 
%     step sizes.
%
%     B = shared_utils.vector.slidebin( ..., DISCARD_UNEVEN ) controls 
%     whether to discard the last bin if it is not of size `WIN`. Default 
%     is false. Pass in the empty array ([]) to use the default.
%
%     B = shared_utils.vector.slidebin( ..., IS_UNIFORM ) indicates whether
%     the output of `FUNC` is uniform; i.e., whether each application of
%     `FUNC` produces a scalar value of the same class. If `IS_UNIFORM` is
%     false, then `B` is a cell array, and `FUNC` can return values of any
%     class or size. Default is true.
%
%     See also shared_utils.vector.slidebin

if ( nargin < 6 || isempty(uniform_output) ), uniform_output = true; end
if ( nargin < 5 || isempty(discard_uneven) ), discard_uneven = false; end
if ( nargin < 4 || isempty(step) ), step = win; end

validateattributes( func, {'function_handle'}, {'scalar'}, 1 );
assert( isvector(a), 'Input data must be a vector.' );
validateattributes( win, {'double'}, {'scalar'}, 3 );
validateattributes( step, {'double'}, {'scalar'}, 4 );
validateattributes( discard_uneven, {'logical'}, {'scalar'}, 5 );
validateattributes( uniform_output, {'logical'}, {'scalar'}, 6 );

if ( isempty(win) ), b = {}; return; end

N = numel( a );
start = 1;
first = true;

if ( uniform_output )
  b = [];
else
  b = {};
end

assign_stp = 1;
non_uniform_output_msg = ...
  'Non-uniform output detected. Set `uniform_output` = true to proceed.';

while ( first || stop <= N )
  stop = min( start + win - 1, N );
  
  ind = start:stop;
  
  if ( isempty(ind) || (discard_uneven && numel(ind) ~= win) )
    break;
  end
  
  res = func( a(ind) );
  
  if ( ~isscalar(res) && uniform_output )
    error( non_uniform_output_msg );
  end
  
  if ( uniform_output )
    if ( first )
      b = res;
    else
      if ( ~strcmp(class(res), class(b)) )
        error( non_uniform_output_msg );
      end
      
      b(end+1) = res;
    end
  else
    b{assign_stp} = res;
  end
  
  start = start + step;
  assign_stp = assign_stp + 1;
  
  first = false;
end

end