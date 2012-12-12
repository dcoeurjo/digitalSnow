#!/bin/zsh

typeset file=$1

echo "OFF file=" $file
typeset PI=3.14159265
typeset ii=0
let "ii= $i*10 " 
typeset MYPATH="/Users/davidcoeurjolly/Sources/digitalSnow/radiativeTransfer/tools/build/"
for theta in {0..90}
do
    echo " =========== Theta $theta ==========="
    for phi in {0..359}
    do
        echo " =========== Phi $phi ==========="
        let "t=$theta*$PI/180"
        let "p=$phi*$PI/180"
        $MYPATH/Noff2Pbrt -i $file -o Data/temp -t $t -p $p >! log
        mv Data/tempPhoton.pbrt Data/temp_$theta-$phi-Photon.pbrt

    done
done
    
