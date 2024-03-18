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

// server:
//      join group
//      listen to events clients
//      print events
int main(int argc, char** argv)
{
    // create tipc socket which will join socket group
    int sockfd = socket(AF_TIPC, SOCK_RDM, 0);

    // tipc socket requests to joins the group
    struct tipc_group_req request;
    request.type = 4711;
    request.instance = 0;
    request.scope = TIPC_NODE_SCOPE;
    setsockopt(sockfd, SOL_TIPC, TIPC_GROUP_JOIN, &request, sizeof(request));
    
    while (1)
    {
        struct msghdr msg;

        struct sockaddr_tipc addresses[2];
        msg.msg_name = &addresses;
        msg.msg_namelen = sizeof(addresses);

        char buffer[32];
        struct iovec iov;
        iov.iov_base = &buffer;
        iov.iov_len = 32;

        msg.msg_iov = &iov;
	    msg.msg_iovlen = 1;

        int num_bytes_received = recvmsg(sockfd, &msg, 0);

        printf("num_bytes_received = %d\n", num_bytes_received);

        for(int i = 0; i < 2; i++)
        {
            struct sockaddr_tipc addr = addresses[i];
            
            printf("address %d:\n", i);
            printf("family=%d, addrtype=%d, scope=%d\n",
                    addr.family, addr.addrtype, addr.scope);

            if (addr.addrtype == TIPC_SERVICE_ADDR)
            {
                printf("service_type=%u, instance=%u\n",
                    addr.addr.name.name.type, addr.addr.name.name.instance);
            }
            else if (addr.addrtype == TIPC_SOCKET_ADDR)
            {
                printf("socket_ref=%u, node=%u\n",
                    addr.addr.id.ref, addr.addr.id.node);
            }
        }

        printf("len=%lu, buffer=%s\n", msg.msg_iov->iov_len, buffer);
    }
    return 0;
}

