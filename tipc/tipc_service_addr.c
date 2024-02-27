#include <sys/types.h>
#include <sys/socket.h>
#include <linux/tipc.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

int main(int argc, char *argv[])
{
	int service_type = 100;
	int instance = 1;

	struct sockaddr_tipc server = {
		.family = AF_TIPC,
		.addrtype = TIPC_SERVICE_ADDR,
		.scope = TIPC_CLUSTER_SCOPE,
		.addr.name.name.type = service_type,
		.addr.name.name.instance = instance
	};

	int sd = socket(AF_TIPC, SOCK_RDM, 0);

	if (0 != bind(sd, (void*)&server, sizeof(server))) {
		printf("Bind failed, error=%s\n", strerror(errno));
		exit(1);
	}

	// Keep process running
	printf("Bind successfully, press Enter to exit...\n");
	while ((getchar()) != '\n') {}
}
