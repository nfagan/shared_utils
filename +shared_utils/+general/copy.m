function b = copy(a)

b = a;

if ( isstruct(a) )
  return;
  
elseif ( isa(a, 'containers.Map') )
  b = copy_map( a );
  
elseif ( isobject(a) && isa(a, 'handle') )
  warning( 'Generic copy for handle objects is not supported.' );
end

end

function b = copy_map(a)

b = containers.Map( 'keytype', a.KeyType, 'valuetype', a.ValueType );
k = keys( a );

for i = 1:numel(k)
  b(k{i}) = a(k{i});
end

end