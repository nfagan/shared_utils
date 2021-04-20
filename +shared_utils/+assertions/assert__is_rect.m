function assert__is_rect(r)

if ( ~shared_utils.rect.is_rect(r) )
  error( 'Expected rect `r` to be a 4-element vector or Mx4 matrix.' );
end

end