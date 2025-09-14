# app
immcfg -c SaAmfAppBaseType safAppType=demo

# sg
immcfg -c SaAmfSGBaseType safSgType=demo

# su
immcfg -c SaAmfSUBaseType safSuType=demo

# si
immcfg -c SaAmfSvcBaseType safSvcType=demo

# comp
immcfg -c SaAmfCompBaseType safCompType=demo

# csi
immcfg -c SaAmfCSBaseType safCSType=demo


# swbundle
immcfg -c SaSmfSwBundle safSmfBundle=demo

# csi
immcfg -c SaAmfCSType safVersion=1,safCSType=demo

# comp
immcfg -c SaAmfCompType \
    -a saAmfCtCompCategory=8 \
    -a saAmfCtSwBundle=safSmfBundle=demo \
    -a saAmfCtDefClcCliTimeout=10000000000 \
    -a saAmfCtRelPathInstantiateCmd='main.sh start' \
    -a saAmfCtRelPathCleanupCmd='main.sh stop' \
    -a saAmfCtRelPathTerminateCmd='main.sh stop' \
    -a saAmfCtRelPathAmStartCmd='../../usr/local/sbin/amfpm --start' \
    -a saAmfCtRelPathAmStopCmd='../../usr/local/sbin/amfpm --stop' \
    -a saAmfCtDefRecoveryOnError=3 \
    -a saAmfCtDefDisableRestart=0 \
    safVersion=1,safCompType=demo

# si
immcfg -c SaAmfSvcType safVersion=1,safSvcType=demo

# su
immcfg -c SaAmfSUType \
    -a saAmfSutIsExternal=0 \
    -a saAmfSutDefSUFailover=1 \
    -a saAmfSutProvidesSvcTypes=safVersion=1,safSvcType=demo \
    safVersion=1,safSuType=demo

# sg
immcfg -c SaAmfSGType \
    -a saAmfSgtRedundancyModel=1 \
    -a saAmfSgtValidSuTypes=safVersion=1,safSuType=demo \
    -a saAmfSgtDefAutoAdjustProb=10000000000 \
    -a saAmfSgtDefCompRestartProb=4000000000 \
    -a saAmfSgtDefCompRestartMax=10 \
    -a saAmfSgtDefSuRestartProb=4000000000 \
    -a saAmfSgtDefSuRestartMax=10 \
    safVersion=1,safSgType=demo

# app
immcfg -c SaAmfAppType \
    -a saAmfApptSGTypes=safVersion=1,safSgType=demo \
    safVersion=1,safAppType=demo

# connect su - comp
immcfg -c SaAmfSutCompType \
    'safMemberCompType=safVersion=1\,safCompType=demo,safVersion=1,safSuType=demo'

# connect comp - csi
immcfg -c SaAmfCtCsType \
    -a saAmfCtCompCapability=1 \
    'safSupportedCsType=safVersion=1\,safCSType=demo,safVersion=1,safCompType=demo'

# connect csi - si
immcfg -c SaAmfSvcTypeCSTypes \
    'safMemberCSType=safVersion=1\,safCSType=demo,safVersion=1,safSvcType=demo'

immcfg -c SaAmfApplication \
    -a saAmfAppType=safVersion=1,safAppType=demo \
    safApp=demo

immcfg -c SaAmfSG \
    -a saAmfSGType=safVersion=1,safSgType=demo \
    -a saAmfSGAutoRepair=0 \
    -a saAmfSGAutoAdjust=0 \
    -a saAmfSGNumPrefInserviceSUs=10 \
    -a saAmfSGNumPrefAssignedSUs=10 \
    safSg=demo,safApp=demo

immcfg -c SaAmfSI \
    -a saAmfSvcType=safVersion=1,safSvcType=demo \
    -a saAmfSIProtectedbySG=safSg=demo,safApp=demo \
    -a saAmfSIRank=1 \
    safSi=demo,safApp=demo

immcfg -c SaAmfCSI \
    -a saAmfCSType=safVersion=1,safCSType=demo \
    safCsi=demo,safSi=demo,safApp=demo

immcfg -c SaAmfNodeSwBundle \
    -a saAmfNodeSwBundlePathPrefix=/opt/demo \
    safInstalledSwBundle=safSmfBundle=demo,safAmfNode=SC-1,safAmfCluster=myAmfCluster

immcfg -c SaAmfSU \
    -a saAmfSUType=safVersion=1,safSuType=demo \
    -a saAmfSUHostNodeOrNodeGroup=safAmfNode=SC-1,safAmfCluster=myAmfCluster \
    -a saAmfSURank=1 \
    -a saAmfSUAdminState=3 \
    safSu=1,safSg=demo,safApp=demo

immcfg -c SaAmfComp \
    -a saAmfCompType=safVersion=1,safCompType=demo \
    safComp=demo,safSu=1,safSg=demo,safApp=demo

immcfg -c SaAmfCompCsType \
    'safSupportedCsType=safVersion=1\,safCSType=demo,safComp=demo,safSu=1,safSg=demo,safApp=demo'


# immcfg -c SaAmfNodeSwBundle \
#     -a saAmfNodeSwBundlePathPrefix=/opt/demo \
#     safInstalledSwBundle=safSmfBundle=demo,safAmfNode=SC-2,safAmfCluster=myAmfCluster

# immcfg -c SaAmfSU \
#     -a saAmfSUType=safVersion=1,safSuType=demo \
#     -a saAmfSUHostNodeOrNodeGroup=safAmfNode=SC-2,safAmfCluster=myAmfCluster \
#     -a saAmfSURank=1 \
#     -a saAmfSUAdminState=3 \
#     safSu=2,safSg=demo,safApp=demo

# immcfg -c SaAmfComp \
#     -a saAmfCompType=safVersion=1,safCompType=demo \
#     safComp=demo,safSu=2,safSg=demo,safApp=demo

# immcfg -c SaAmfCompCsType \
#     'safSupportedCsType=safVersion=1\,safCSType=demo,safComp=demo,safSu=2,safSg=demo,safApp=demo'
