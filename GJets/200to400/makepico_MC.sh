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

cd /home/akobert/CMSSW_10_6_19_patch2/src/GJets/200to400
eval `scramv1 runtime -sh`

source MakePico.sh MC25 /cms/xaastorage/NanoAOD/2018/JUNE19/GJetsHTBinned_Test/GJetsHT_200to400/jetToolbox_nano_mc_2018GJetsHT200to400_$2 /home/akobert/CMSSW_10_6_19_patch2/src/gobetween 2018 MC triglist2018MC.txt $wgt > /home/akobert/CMSSW_10_6_19_patch2/src/CondorFiles/logfiles_GJets200to400_$1_$2.log


