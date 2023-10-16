#!/bin/bash    

#source MakePico.sh [output] [inputPath] [goBetween] [year] [Run/MC] [TriggerList] [weight]

cluster=$1
process=$2

# CMSSW setup etc
export SCRAM_ARCH="slc7_amd64_gcc700"
export VO_CMS_SW_DIR="/cms/base/cmssoft"
export COIN_FULL_INDIRECT_RENDERING=1
source $VO_CMS_SW_DIR/cmsset_default.sh


# RPV stop M800
#xsec=0.0326  # in pb got this from LHC SUSY xsec page
#nevt=509202  # got this from DAS
#wgt=$(echo $xsec / $nevt | bc -l)
wgt=1
echo $wgt

cd /home/akobert/CMSSW_10_6_19_patch2/src/UL/QCD/700to1000
eval `scramv1 runtime -sh`

source MakePico.sh QCD700to1000 /cms/akobert/UL/QCD/700to1000/jetToolbox_nano_mc_2018QCDHT700to1000_$2 /home/akobert/CMSSW_10_6_19_patch2/src/gobetween UL2018 MC triglist2018MC.txt $wgt > /home/akobert/CMSSW_10_6_19_patch2/src/CondorFiles/logfiles_QCD700to1000_$1_$2.log


