#!/bin/bash    

#source MakePico.sh [output] [inputPath] [goBetween] [year] [Run/MC] [TriggerList] [weight]

# RPV stop M800
#xsec=0.0326  # in pb got this from LHC SUSY xsec page
#nevt=509202  # got this from DAS
#wgt=$(echo $xsec / $nevt | bc -l)
wgt=1
echo $wgt

cd /home/akobert/CMSSW_10_6_19_patch2/src/
eval `scramv1 runtime -sh`

source MakePico.sh data_EGamma_Run2018A /home/akobert/CMSSW_10_2_22/src/rucio/jetToolbox_nano_datatest /cms/evah/workspace/CMSSW_10_6_19_patch2/src/gobetween 2018 A triglist2018Data.txt $wgt


