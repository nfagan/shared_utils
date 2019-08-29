function events_b = cinterp(events_a, clock_a, clock_b, allow_out_of_range)

%   CINTERP -- Interpolate time values between different clocks.
%
%     B = ... cinterp( A, clock_a, clock_b ) expresses the time-points of
%     `A` in terms of another clock, `clock_b`. `A` is an array of numeric
%     values. `clock_a` is a vector of continuously increasing time-stamps
%     with units equivalent to those of `A`; `clock_b` is a vector the 
%     same size as `clock_a` where each element `i` is the value of 
%     `clock_b` corresponding to time `clock_a(i)`.
%
%     Values in `A` smaller than the smallest element of `clock_a`, or 
%     larger than the largest element of `clock_a`, will be NaN in `B`.
%     Additionally, if `clock_a` has only a single element, then values in
%     `B` will either be the corresponding value of `clock_b`, or NaN.
%
%     B = ... cinterp( ..., RANGE_FLAG ) specifies whether to interpolate
%     values in `A` that fall outside the range of values in `clock_a`.
%     This interpolation can become quite inaccurate for values of `A` that
%     are far outside the range of `clock_a`, or for clocks that are prone 
%     to drift. Default is false.
%
%     Neither `clock_a` nor `clock_b` can contain NaN values.

if ( nargin < 4 )
  allow_out_of_range = false;
end

n_clock_samples = numel( clock_a );

assert( n_clock_samples == numel(clock_b), ...
  'Synchronization vectors must have the same number of elements.' );

clock_a = clock_a(:);
clock_b = clock_b(:);

fname = 'cinterp';

validateattributes( events_a, {'numeric'}, {}, fname, 'events', 1 );
validateattributes( clock_a, {'numeric'}, {'nonempty', 'nonnan'}, fname, 'clock_a', 2 );
validateattributes( clock_b, {'numeric'}, {'nonempty', 'nonnan'}, fname, 'clock_b', 3 );
validateattributes( allow_out_of_range, {'logical'}, {'scalar'}, fname, 'allow_out_of_range' );

events_b = nan( size(events_a) );

use_out_of_range = allow_out_of_range && n_clock_samples >= 2;

if ( use_out_of_range )
  ratio_ab = get_out_of_range_clock_ratio( clock_a, clock_b );
end

for i = 1:numel(events_a)
  t = events_a(i);
  
  if ( isnan(t) )
    continue;
  end
  
  [~, I] = min( abs(clock_a - t) );
  
  sync_a = clock_a(I);
  
  % times match exactly
  if ( sync_a == t )
    events_b(i) = clock_b(I);
    continue;
  end
  
  if ( t < sync_a )
    % target-time is before sync time
    if ( I == 1 )
      % time is before first sync time
      if ( use_out_of_range )
        events_b(i) = get_out_of_range_before( t, clock_a, clock_b, ratio_ab );
      end
      continue;
    else
      t1a = clock_a(I-1);
      t1b = clock_b(I-1);
    end
    
    t2a = clock_a(I);
    t2b = clock_b(I);
  else
    % target-time is after sync time
    t1a = clock_a(I);
    t1b = clock_b(I);
    
    if ( I == numel(clock_a) )
      % time is after last sync time.      
      if ( use_out_of_range )
        events_b(i) = get_out_of_range_after( t, clock_a, clock_b, ratio_ab );
      end
      continue;
    else
      t2a = clock_a(I+1);
      t2b = clock_b(I+1);
    end
  end
  
  assert( ~isnan(t1a) && ~isnan(t2a), 'No sync times matched??' );
  
  frac = (t - t1a) / (t2a - t1a);
  events_b(i) = ((t2b - t1b) * frac) + t1b;
end

end

function event_b = get_out_of_range_after(event_a, clock_a, clock_b, ratio)

offset_b = (event_a - clock_a(end)) / ratio;
event_b = clock_b(end) + offset_b;

end

function event_b = get_out_of_range_before(event_a, clock_a, clock_b, ratio)

offset_b = (clock_a(1) - event_a) / ratio;
event_b = clock_b(1) - offset_b;

end

function ratio_ab = get_out_of_range_clock_ratio(clock_a, clock_b)

diff_a = diff( clock_a );
diff_b = diff( clock_b );

ratio_ab = median( diff_a ./ diff_b );  

end