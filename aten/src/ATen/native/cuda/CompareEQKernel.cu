#include <ATen/Dispatch.h>
#include <ATen/native/BinaryOps.h>
#include <ATen/native/DispatchStub.h>
#include <ATen/native/TensorIterator.h>
#include <ATen/native/cuda/Loops.cuh>


// NOTE: CUDA on Windows requires that the enclosing function
// of a __device__ lambda not have internal linkage.

namespace at { namespace native {

void eq_kernel_cuda(TensorIterator& iter) {
  AT_DISPATCH_ALL_TYPES_AND_COMPLEX_AND3(kHalf, kBFloat16, kBool, iter.common_dtype(), "eq_cuda", [&]() {
    gpu_kernel_with_scalars(iter, []GPU_LAMBDA(scalar_t a, scalar_t b) -> bool {
      return a == b;
    });
  });
}

REGISTER_DISPATCH(eq_stub, &eq_kernel_cuda);

}} // namespace at::native
