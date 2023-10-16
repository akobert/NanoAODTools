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
echo $process

cd /home/akobert/CMSSW_10_6_19_patch2/src/2016/QCD/2000toInf_APV
eval `scramv1 runtime -sh`

echo "test1"

i=0
for x in `cat test.txt`
do
echo $i
if [ $i == $process ]
then
	echo "test2"
	echo $x
	ifile=$x
	break
fi
((i=i+1))
done

echo $ifile

source MakePico.sh QCD2000toInf_APV $ifile /home/akobert/CMSSW_10_6_19_patch2/src/gobetween UL2016_preVFP MC triglist2016MC.txt $wgt > /home/akobert/CMSSW_10_6_19_patch2/src/CondorFiles/logfiles_QCD2000toInf_APV_2016_$1_$2.log
