% f = figure( 1 );

root = shared_utils.gui.MatrixLayout( 2, 3 );
child1 = shared_utils.gui.MatrixLayout( 1, 1 );
child2 = shared_utils.gui.MatrixLayout( 1, 1 );
child3 = shared_utils.gui.MatrixLayout( 1, 1 );
child4 = shared_utils.gui.MatrixLayout( 1, 1 );

tic;

root.assign( 1:2, 1, child1 );
child1.assign( 1, 1, child2 );

deparent( child2 );
root.assign( 1, 1, child2 );
child2.assign( 1, 1, child3 );
root.assign( 1, 3, child4 );

assert( root.contents{1} == child2 );
assert( isempty(child1.contents{1}) && isempty(child1.parent) );
assert( isempty(child3.contents{1}) );

cat_test_assert_fail( @() child3.assign(1, 1, root), 'Allowed cyclic ref.' );
cat_test_assert_fail( @() root.assign(1, 1, child3), 'Allowed cyclic ref.' );
cat_test_assert_fail( @() root.assign(1, 1, child2), 'Allowed cyclic ref.' );

deparent( child2 );
deparent( child4 );

child2.assign( 1, 1, child4 );

assert( isempty(child3.contents{1}) );
assert( all(cellfun('isempty', root.contents(:))) );

toc;

%%



