
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <poll.h>
#include <syslog.h>
#include <signal.h>
#include <saAmf.h>
#include <saAis.h>


#define trace(fmt, ...) \
    syslog(LOG_INFO, "%s: " fmt, __FUNCTION__, ##__VA_ARGS__)


void csiSetCallback(SaInvocationT invocation, const SaNameT *name,
    SaAmfHAStateT state, SaAmfCSIDescriptorT descriptor);

void csiRemoveCallback(SaInvocationT invocation, const SaNameT *compName,
    const SaNameT *csiName, SaAmfCSIFlagsT csiFlags);

void componentTerminateCallback(SaInvocationT invocation,
    const SaNameT *compName);

void csiAttributeChangeCallback(SaInvocationT invocation,
    const SaNameT *csiName, SaAmfCSIAttributeListT csiAttr);


SaAmfHandleT amfHandler;


int main(int argc, char ** argv)
{
    // setup syslog
    openlog("demo", LOG_PID, LOG_USER);
    trace("start");

    // check if program start by AMF
    // SA_AMF_COMPONENT_NAME exists when started by amf
    if (getenv("SA_AMF_COMPONENT_NAME") == NULL)
    {
        trace("not started by AMF, exiting...\n");
        return 1;
    }

    // setup amf callbacks
    SaAmfCallbacksT_o4 callbacks = {0};
    callbacks.saAmfCSISetCallback = csiSetCallback;
    callbacks.saAmfCSIRemoveCallback = csiRemoveCallback;
    callbacks.saAmfComponentTerminateCallback= componentTerminateCallback;
    callbacks.osafCsiAttributeChangeCallback = csiAttributeChangeCallback;
    SaVersionT apiVersion = {
        .releaseCode = 'B',
        .majorVersion = 0x04,
        .minorVersion = 0x02
    };
    saAmfInitialize_o4(&amfHandler, &callbacks, &apiVersion);

    // register component
    SaNameT name;
    saAmfComponentNameGet(amfHandler, &name);
    saAmfComponentRegister(amfHandler, &name, 0);

    // get file descriptor that listens incoming amf callbacks
    SaSelectionObjectT monitorFd;
    saAmfSelectionObjectGet(amfHandler, &monitorFd);

    // setup pollfd to monitor amf callback events
    struct pollfd fds[1];
    fds[0].fd = monitorFd;
    fds[0].events = POLLIN;

    // wait and handle amf callback events
    while (poll(fds, 1, -1) != -1)
    {
        if (fds[0].revents & POLLIN)
        {
            trace("receive poll event");
            saAmfDispatch(amfHandler, SA_DISPATCH_ONE);
        }
    }

    return 1;
}


void csiSetCallback(SaInvocationT invocation, const SaNameT *name,
    SaAmfHAStateT state, SaAmfCSIDescriptorT descriptor)
{
    trace();
    saAmfResponse_4(amfHandler, invocation, 0, SA_AIS_OK);
}


void csiRemoveCallback(SaInvocationT invocation, const SaNameT *compName,
    const SaNameT *csiName, SaAmfCSIFlagsT csi_flags)
{
    trace();
    saAmfResponse_4(amfHandler, invocation, 0, SA_AIS_OK);
}


void componentTerminateCallback(SaInvocationT invocation,
    const SaNameT *compName)
{
    trace();
    saAmfResponse_4(amfHandler, invocation, 0, SA_AIS_OK);
}


void csiAttributeChangeCallback(SaInvocationT invocation,
    const SaNameT *csiName, SaAmfCSIAttributeListT csiAttr)
{
    trace();
    saAmfResponse_4(amfHandler, invocation, 0, SA_AIS_OK);
}
  

