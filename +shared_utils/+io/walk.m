function [outs, subfolders] = walk(p, func, varargin)

%   WALK -- Apply function recursively to subfolders.
%
%     walk( P, FUNC ) applies `FUNC` to each subfolder of `P`. `FUNC` is a
%     handle to a function that accepts two inputs: the absolute path to a
%     subfolder of `P`, and the depth of the subfolder, where e.g. 1
%     indicates that the current subfolder is one directory below `P`. In
%     this case, `FUNC` cannot return outputs.
%
%     [A, B] = walk( P, FUNC, 'outputs', true ) returns outputs of `FUNC` 
%     in `A`. `FUNC` is a handle to function that accepts inputs as above, 
%     and returns two outputs: the result of the function, and a logical 
%     value indicating whether to assign that result to `A`.
%
%     ... = walk( ..., 'max_depth', N ) visits subfolders that are nested 
%     at maximum `N` subfolders below `P`.
%
%     IN:
%       - `p` (char)
%       - `func` (function_handle)
%       - `varargin` ('name', value)
%     OUT:
%       - `outs` (cell array)
%       - `identifiers` (cell array of strings)

defaults = struct();
defaults.max_depth = Inf;
defaults.outputs = false;

params = parsestruct( defaults, varargin );

if ( nargout > 0 )
  assert( params.outputs, 'Set (''outputs'', true) to obtain outputs.' );
end

[outs, subfolders] = walk_impl( p, func, 0, {}, {}, {}, params );
outs = outs(:);

end

function [outs, all_priors, priors] = walk_impl(p, func, level, outs, all_priors, priors, params)

folders = shared_utils.io.dirnames( p, 'folders' );

if ( level > params.max_depth )
  return;
end

for i = 1:numel(folders)
  priors{level+1} = folders{i};
  
  [outs, all_priors, priors] = walk_impl( ...
    fullfile(p, folders{i}), func, level+1, outs, all_priors, priors, params ...
  );
end

if ( params.outputs )
  [res, should_assign] = func( p, level );
else
  func( p, level );
  return;
end

if ( should_assign )
  outs(end+1) = res;
  all_priors(end+1, :) = priors(:)';
end

end

function params = parsestruct(params, args)

names = fieldnames(params);

nArgs = length(args);

if round(nArgs/2)~=nArgs/2
   error('Name-value pairs are incomplete!')
end

for pair = reshape(args,2,[])
   inpName = pair{1};
   if any(strcmp(inpName,names))
      params.(inpName) = pair{2};
   else
      error('%s is not a recognized parameter name',inpName)
   end
end

end