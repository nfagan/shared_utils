#include "mex.h"
#include <cmath>
#include <cstddef>
#include <cstdlib>
#include <limits>

struct ValidationOutputs {
  std::size_t n_referent_elements;
  std::size_t n_target_elements;  
  
  ValidationOutputs() : n_referent_elements(0), n_target_elements(0) {}
  ~ValidationOutputs() = default;
};

ValidationOutputs validate(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  ValidationOutputs validation;
  
  if (nlhs > 1) {
    mexErrMsgIdAndTxt("find_nearest:nout", "Wrong number of output arguments.");
    return validation;
  }
  
  if (nrhs != 2) {
    mexErrMsgIdAndTxt("find_nearest:nin", "Wrong number of input arguments.");
    return validation;
  }
  
  const mxArray *referent = prhs[0];
  const mxArray *target = prhs[1];
  
  if (!mxIsDouble(referent)) {
    mexErrMsgIdAndTxt("find_nearest:inputtype", "Referent array must be double.");
    return validation;
  }
  
  if (!mxIsDouble(target)) {
    mexErrMsgIdAndTxt("find_nearest:inputtype", "Target array must be double.");
    return validation;
  }
  
  if (mxIsComplex(referent)) {
    mexErrMsgIdAndTxt("find_nearest:inputtype", "Referent array cannot be complex.");
    return validation;
  }
  
  if (mxIsComplex(target)) {
    mexErrMsgIdAndTxt("find_nearest:inputtype", "Target array cannot be complex.");
    return validation;
  }
  
  validation.n_target_elements = mxGetNumberOfElements(target);
  validation.n_referent_elements = mxGetNumberOfElements(referent);
  
  if (validation.n_referent_elements == 0) {
    mexErrMsgIdAndTxt("find_nearest:inputtype", "Referent array cannot be empty.");
    return validation;
  }
  
  return validation;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  
  ValidationOutputs validation = validate(nlhs, plhs, nrhs, prhs);
  
  const mxArray *referent = prhs[0];
  const mxArray *target = prhs[1];
  
  const mwSize *target_dims = mxGetDimensions(target);
  std::size_t target_n_dims = mxGetNumberOfDimensions(target);
  std::size_t* target_dims_size_t = (std::size_t*)target_dims;
  
  std::size_t n_target_elements = validation.n_target_elements;
  std::size_t n_ref_elements = validation.n_referent_elements;
  
  mxArray *out_indices = mxCreateUninitNumericArray(target_n_dims, target_dims_size_t,
          mxDOUBLE_CLASS, mxREAL);
  
  plhs[0] = out_indices;
  
  if (n_target_elements == 0) {
    return;
  }

  double *out_ptr = mxGetPr(out_indices);
  
  const double *target_ptr = mxGetPr(target);
  const double *ref_ptr = mxGetPr(referent);
  
  double abs_max = std::numeric_limits<double>::infinity();
  
  for (std::size_t i = 0; i < n_target_elements; i++) {
    double v = target_ptr[i];
    
    if (std::isnan(v)) {
      out_ptr[i] = std::nan("");
      continue;
    }
    
    double m = abs_max;
    double idx = 1.0;
    bool is_all_nan = true;
    
    for (std::size_t j = 0; j < n_ref_elements; j++) {
      double ref = ref_ptr[j];
      
      if (std::isnan(ref)) {
        continue;
      }
      
      is_all_nan = false;
      
      double d = abs(v - ref);
      
      if (d < m) {
        idx = double(j) + 1.0;
        m = d;
      }
    }
    
    //  all elements of "referent" are nan, so nearest index is NaN
    if (is_all_nan) {
      out_ptr[i] = std::nan("");
    } else {
      out_ptr[i] = idx;
    }
  }
}