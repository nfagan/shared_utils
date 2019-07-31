function outputs = extract_outputs_from_results(results, uniform_output)

%   EXTRACT_OUTPUTS_FROM_RESULTS
%
%     outputs = shared_utils.pipeline.extract_outputs_from_results( results );
%     returns the concatenated array of 'output' fields in `results` as a
%     homogeneous array.
%
%     outputs = shared_utils.pipeline.extract_outputs_from_results( ..., uniform_output )
%     indicates whether each 'output' field in `results` is compatible with
%     horizontal conatenation. If false, `outputs` is a cell array.
%
%     See also shared_utils.pipeline.LoopedMakeRunner

if ( nargin < 2 )
  uniform_output = true;
else
  validateattributes( uniform_output, {'logical'}, {'scalar'}, mfilename, 'uniform output' );
end

if ( uniform_output )
  outputs = [ results([results.success]).output ];
else
  outputs = { results([results.success]).output };
end

end