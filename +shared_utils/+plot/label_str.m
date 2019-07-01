function label_strs = label_str(label_strs)

%   LABEL_STR -- Make label appropriate for title or legend.
%
%     label = shared_utils.plot.label_str( label ); removes select characters 
%     from `label` that could be interpted as LATEX formatting specifiers. 
%     For example, underscores in `label` are replaced with a space.
%
%     See also legend, xlabel, ylabel

if ( iscell(label_strs) )
  label_strs = cellfun( @trim_func, label_strs, 'un', 0 );
else
  label_strs = trim_func( label_strs );
end

end

function str = trim_func(str)

str = strrep( str, '_', ' ' );

end