#!/bin/bash    

#source MakePico.sh [output] [inputPath] [goBetween] [year] [Run/MC] [TriggerList] [weight]

# RPV stop M800
#xsec=0.0326  # in pb got this from LHC SUSY xsec page
#nevt=509202  # got this from DAS
#wgt=$(echo $xsec / $nevt | bc -l)
wgt=1
echo $wgt
job=$2
echo $job
cd /home/akobert/CMSSW_10_6_19_patch2/src/dataRunA/batch1
eval `scramv1 runtime -sh`

source MakePico.sh data_EGamma_Run2018A /cms/xaastorage/NanoAOD/2018/JUNE19/EGamma_RunA_Test/jetToolbox_nano_datatest_$job /cms/xaastorage/gobetween 2018 A triglist2018Data.txt $wgt > /home/akobert/CMSSW_10_6_19_patch2/src/CondorFiles/logfiles_dataA_$1_$2.log


