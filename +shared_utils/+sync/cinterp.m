function events_b = cinterp(events_a, clock_a, clock_b)

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
%     Neither `clock_a` nor `clock_b` can contain NaN values.
%
%     IN:
%       - `events_a` (double)
%       - `clock_a` (double)
%       - `clock_b` (double)
%     OUT:
%       - `events_b` (double)

assert( numel(clock_a) == numel(clock_b), ...
  'Synchronization vectors must have the same number of elements.' );

clock_a = clock_a(:);
clock_b = clock_b(:);

fname = 'cinterp';

validateattributes( events_a, {'numeric'}, {}, fname, 'events', 1 );
validateattributes( clock_a, {'numeric'}, {'nonempty', 'nonnan'}, fname, 'clock_a', 2 );
validateattributes( clock_b, {'numeric'}, {'nonempty', 'nonnan'}, fname, 'clock_b', 3 );

events_b = nan( size(events_a) );

for i = 1:numel(events_a)
  t = events_a(i);
  
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