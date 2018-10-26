function mex_build()

if ( isunix() && ~ismac() )
  compiler_spec = 'GCC=''/usr/bin/gcc-4.9'' G++=''/usr/bin/g++-4.9'' ';
  cxx_flags = '';
else
  cxx_flags = '';
  compiler_spec = '';
end

funcs = { 'find_nearest.cpp' };

p = fileparts( which('shared_utils.sync.mex_build') );
mex_funcs = cellfun( @(x) fullfile(p, x), funcs, 'un', false );

mex_func = strjoin( mex_funcs, ' ' );

build_cmd = sprintf( '-v %s%s COPTIMFLAGS="-O3 -fwrapv -DNDEBUG" CXXOPTIMFLAGS="-O3 -fwrapv -DNDEBUG" -outdir %s %s' ...
  , compiler_spec, cxx_flags, p, mex_func );

eval( sprintf('mex %s', build_cmd) );

end
