#!/bin/bash    

#source MakePico.sh [output] [inputPath] [goBetween] [year] [Run/MC] [TriggerList] [weight]

# RPV stop M800
#xsec=0.0326  # in pb got this from LHC SUSY xsec page
#nevt=509202  # got this from DAS
#wgt=$(echo $xsec / $nevt | bc -l)
wgt=1
echo $wgt

cd /home/akobert/CMSSW_10_6_19_patch2/src/UL/dataRunD
eval `scramv1 runtime -sh`

source MakePico.sh data_EGamma_Run2018D /cms/xaastorage/NanoAOD/2018/JUNE19/UL/EGamma_RunD/jetToolbox_dataD2018_$2 /cms/xaastorage/gobetween UL2018 D triglist2018Data.txt $wgt > /home/akobert/CMSSW_10_6_19_patch2/src/CondorFiles/logfiles_dataD_$1_$2.log


