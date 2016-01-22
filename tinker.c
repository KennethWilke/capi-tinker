#include "tinker.h"


int main(int argc, char *argv[])
{
	struct cxl_afu_h *afu;
	__u64 wed = 0xDEADBEEF;

	afu = cxl_afu_open_dev("/dev/cxl/afu0.0d");
	if(!afu)
	{
		printf("Failed to open AFU: %m\n");
		return 1;
	}

	cxl_afu_attach(afu, (__u64)wed);

	cxl_afu_free(afu);

	return 0;
}
