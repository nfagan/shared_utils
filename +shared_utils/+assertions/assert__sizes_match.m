function assert__sizes_match(kind, varargin)

%   ASSERT__SIZES_MATCH -- Ensure elements have identical sizes.
%
%     IN:
%       - `kind` (char) -- Indicate the kind of elements being checked, in
%         case the assertion fails.
%       - `varargin` (any)

if ( nargin == 0 || ~ischar(kind) )
  kind = '(unspecified)';
end

for i = 1:numel(varargin)
  if ( i == 1 )
     last_sz = size( varargin{i} );
    continue; 
  end
  
  sz = size( varargin{i} );
  
  if ( numel(sz) ~= numel(last_sz) || ~all(sz(:) == last_sz(:)) )
    error( 'Array elements of type "%s" must have identical sizes.', kind );
  end
  
  last_sz = sz;
end

end