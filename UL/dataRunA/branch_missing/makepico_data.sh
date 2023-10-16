#!/bin/bash    

#source MakePico.sh [output] [inputPath] [goBetween] [year] [Run/MC] [TriggerList] [weight]

# RPV stop M800
#xsec=0.0326  # in pb got this from LHC SUSY xsec page
#nevt=509202  # got this from DAS
#wgt=$(echo $xsec / $nevt | bc -l)
wgt=1
echo $wgt

cd /home/akobert/CMSSW_10_6_19_patch2/src/UL/dataRunA/branch_missing
eval `scramv1 runtime -sh`

filename=test.txt
file=$(sed -n $(echo $(($2+1)))p $filename)

echo $file

source MakePico.sh data_EGamma_Run2018A $file /cms/xaastorage/gobetween UL2018 A triglist2018Data.txt $wgt > /home/akobert/CMSSW_10_6_19_patch2/src/CondorFiles/logfiles_dataA_$1_$2.log


