#!/bin/bash    

#source MakePico.sh [output] [inputPath] [goBetween] [year] [Run/MC] [TriggerList] [weight]

cluster=$1
process=$2

i=0
for x in `cat test.txt`
do
if [ $i == $process ]
then
	ifile=$x
	echo $i
	break
fi
((i=i+1))
done
echo $process
echo $ifile

ls $ifile

[[ $var == *$'\r'* ]] && echo yes || echo no
