function lims = contracted_limits(data, factor)

%   CONTRACTED_LIMITS -- Compute axes limits by pinching towards the center
%     of the minimum and maximum values.
%
%     lims = ... contracted_limits( data, factor ); computes axes limits 
%     `lims` such that 

validateattributes( factor, {'double'}, {'scalar'}, mfilename, 'factor' );
assert( factor >= 0 && factor < 1 ...
  , 'Expected `contract_amount` in range [0, 1).' );

mn = min( data(:) );
mx = max( data(:) );

if ( isnan(mn) || isnan(mx) )
  warning( 'Minimum or maximum were nan; resulting limits will be arbitrary.' );
  lims = [0, 1];
  
elseif ( isempty(data) )
  warning( 'Data were empty; resulting limits will be arbitrary.' );
  lims = [0, 1];
  
else
  span = mx - mn;
  center = span * 0.5 + mn;
  new_span = span * (1 - factor);
  lims = [center - new_span * 0.5, center + new_span * 0.5];  
end

end