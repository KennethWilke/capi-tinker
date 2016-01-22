#include "tinker.h"


int main(int argc, char *argv[])
{
	struct cxl_afu_h *afu;
	__u64 wed = 0x48656c6c6f414655;

	afu = cxl_afu_open_dev("/dev/cxl/afu0.0d");
	if(!afu)
	{
		printf("Failed to open AFU: %m\n");
		return 1;
	}

	cxl_afu_attach(afu, wed);

	printf("Waiting for 2 minutes\n");
	sleep(120);

	printf("releasing AFU\n");
	cxl_afu_free(afu);

	return 0;
}
