immcfg -c SaSmfSwBundle safSmfBundle=demo

immcfg -c SaAmfNodeSwBundle \
    -a saAmfNodeSwBundlePathPrefix=/opt/demo \
    safInstalledSwBundle=saSmfBundle=demo,safAmfNode=SC-1,safAmfCluster=myAmfCluster

immcfg -c SaAmfAppBaseType safAppType=demo

immcfg -c SaAmfSGBaseType safSgType=demo

immcfg -c SaAmfSUBaseType safSuType=demo

immcfg -c SaAmfSvcBaseType safSvcType=demo

immcfg -c SaAmfCompBaseType safCompType=demo

immcfg -c SaAmfCSBaseType safCSType=demo


immcfg -c SaAmfCSType safVersion=1,safCSType=demo

immcfg -c SaAmfSvcType safVersion=1,safSvcType=demo

immcfg -c SaAmfCompType \
    -a saAmfCtCompCategory=1 \
    -a saAmfCtSwBundle=saSmfBundle=demo \
    -a saAmfCtDefClcCliTimeout=10000000000 \
    -a saAmfCtDefCallbackTimeout=10000000000 \
    -a saAmfCtRelPathInstantiateCmd=control.sh \
    -a saAmfCtDefInstantiateCmdArgv=start \
    -a saAmfCtRelPathCleanupCmd=control.sh \
    -a saAmfCtDefCleanupCmdArgv=stop \
    -a saAmfCtDefQuiescingCompleteTimeout=10000000000 \
    -a saAmfCtDefRecoveryOnError=2 \
    -a saAmfCtDefDisableRestart=0 \
    safVersion=1,safCompType=demo

immcfg -c SaAmfSUType \
    -a saAmfSutProvidesSvcTypes=safVersion=1,safSvcType=demo \
    -a saAmfSutIsExternal=0 \
    -a saAmfSutDefSUFailover=1 \
    safVersion=1,safSuType=demo

immcfg -c SaAmfSGType \
    -a saAmfSgtValidSuTypes=safVersion=1,safSuType=demo \
    -a saAmfSgtRedundancyModel=1 \
    -a saAmfSgtDefSuRestartProb=4000000000 \
    -a saAmfSgtDefSuRestartMax=3 \
    -a saAmfSgtDefCompRestartProb=4000000000 \
    -a saAmfSgtDefCompRestartMax=3 \
    -a saAmfSgtDefAutoAdjustProb=10000000000 \
    safVersion=1,safSgType=demo

immcfg -c SaAmfAppType \
    -a saAmfApptSGTypes=safVersion=1,safSgType=demo \
    safVersion=1,safAppType=demo


immcfg -c SaAmfSutCompType \
    'safMemberCompType=safVersion=1\,safCompType=demo,safVersion=1,safSuType=demo'

immcfg -c SaAmfCtCsType \
    -a saAmfCtCompCapability=1 \
    'safSupportedCsType=safVersion=1\,safCSType=demo,safVersion=1,safCompType=demo'


immcfg -c SaAmfSvcTypeCSTypes \
    'safMemberCSType=safVersion=1\,safCSType=demo,safVersion=1,safSvcType=demo'


immcfg -c SaAmfApplication \
    -a saAmfAppType=safVersion=1,safAppType=demo \
    safApp=demo

immcfg -c SaAmfSG \
    -a saAmfSGType=safVersion=1,safSgType=demo \
    -a saAmfSGSuHostNodeGroup=safAmfNodeGroup=SCs,safAmfCluster=myAmfCluster \
    -a saAmfSGAutoRepair=0 \
    -a saAmfSGAutoAdjust=0 \
    -a saAmfSGNumPrefInserviceSUs=10 \
    -a saAmfSGNumPrefAssignedSUs=10 \
    safSg=demo,safApp=demo

immcfg -c SaAmfSI \
    -a saAmfSvcType=safVersion=1,safSvcType=demo \
    -a saAmfSIProtectedbySG=safSg=demo,safApp=demo \
    safSi=demo,safApp=demo

immcfg -c SaAmfCSI \
    -a saAmfCSType=safVersion=1,safCSType=demo \
    safCsi=demo,safSi=demo,safApp=demo


immcfg -c SaAmfSU \
    -a saAmfSUType=safVersion=1,safSuType=demo \
    -a saAmfSURank=1 \
    -a saAmfSUAdminState=3 \
    safSu=SC-1,safSg=demo,safApp=demo

immcfg -c SaAmfComp \
    -a saAmfCompType=safVersion=1,safCompType=demo \
    safComp=demo,safSu=SC-1,safSg=demo,safApp=demo

immcfg -c SaAmfCompCsType \
    'safSupportedCsType=safVersion=1\,safCSType=demo,safComp=demo,safSu=SC-1,safSg=demo,safApp=demo'

immcfg -c SaAmfHealthcheckType \
    -a saAmfHctDefPeriod=10000000000 \
    -a saAmfHctDefMaxDuration=5000000000 \
    safHealthcheckKey=demo,safVersion=1,safCompType=demo