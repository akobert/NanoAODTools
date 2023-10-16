#!/bin/bash    

export SCRAM_ARCH="slc7_amd64_gcc700"
export VO_CMS_SW_DIR="/cms/base/cmssoft"
export COIN_FULL_INDIRECT_RENDERING=1
source $VO_CMS_SW_DIR/cmsset_default.sh
eval `scramv1 runtime -sh`

echo "--------------------   --------------------   --------------------"

#export NANODIR=/cms/evah/workspace/CMSSW_10_6_19_patch2/src/NanoToolOutput/$4/v7/SKIM_$1
export NANODIR=/cms/akobert/NanoToolOutput/2016/SingleMuon/RunF

echo $NANODIR

mkdir -p $NANODIR

FILES=$2
for f in $FILES
do
    filename=$(basename -- "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"
    echo $filename
    echo "------------------> Pre-Processing $f"

    fo=$NANODIR/$filename''.root
#    echo $fo 

    python preprocess.py $f $NANODIR $4 $5 $6 $fo # input output year run triglist json haddout

#    echo "------------------> hadd  $NANODIR/$filename"'_'"Skim.root"
#    hadd -f $NANODIR/$filename'_'Skim'_'hadd.root $NANODIR/$filename'_'Skim.root
    rm $NANODIR/$filename'_'Skim.root
done



