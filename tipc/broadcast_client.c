#include <sys/types.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/param.h>
#include <errno.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/epoll.h>
#include <sys/time.h>
#include <sys/prctl.h>
#include <linux/socket.h>
#include <linux/tipc.h>
#include <sys/types.h>

// client:
//      join group
//      send broadcast message
int main(int argc, char** argv)
{
    // create tipc socket
    int socket_fd = socket(AF_TIPC, SOCK_RDM, 0);

    // tipc socket joins the group
    struct tipc_group_req request;
    request.type = 4711;
    request.instance = 0;
    request.scope = TIPC_NODE_SCOPE;
    setsockopt(socket_fd, SOL_TIPC, TIPC_GROUP_JOIN, &request, sizeof(request));

    // send broadcast message
    char buf[32] = "hello";
    int ret = send(socket_fd, buf, strlen(buf)+1, 0);
    printf("sent %d bytes, error=%s\n", ret, strerror(errno));

    return 0;
}

