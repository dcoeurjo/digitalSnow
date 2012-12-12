#!/bin/zsh

typeset file=$1
typeset sx=$2
typeset sy=$3
typeset sz=$4
typeset r=$5


echo "OFF file=" $file
typeset PI=3.14159265
integer ii=0
(( ii= i*10 ))
cd /home/davidcoeurjolly/Sources/digitalSnow/radiativeTransfer/tools/build/Data
echo $PWD
for theta in {0..2}
do
    echo "=========== Theta $theta ==========="
    for phi in {0..2}
    do
        echo "=========== Phi $phi ==========="
        let "t=$theta*$PI/180"
        let "p=$phi*$PI/180"
	echo "    Generating pbrt..."
        ../Noff2Pbrt -i ../$file -o temp -t $theta -p $phi >! log
	mv tempPhoton.pbrt temp_$theta-$phi-Photon.pbrt
	for lambda in {70..71}0
	do
	    echo "=========== Lambda $lambda ==========="
	    echo "    Shooting..."
	    time pbrt -p -w $lambda$ -x $sx -y $sy -z $sz -r $r -t $theta -phi $phi --ncores 8 temp_$theta-$phi-Photon.pbrt
	done
    done
done
