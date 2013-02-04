#!/bin/zsh
zmodload zsh/mathfunc     

# NOFF filename
typeset file=$1

#initial volume size
typeset sx=$2
typeset sy=$3
typeset sz=$4

#initial volume resolution
typeset r=$5


echo "OFF file=" $file
typeset PI=3.14159265
integer ii=0
typeset x=0.0;
typeset y=0.0;
typeset z=0.0;
typeset t=0.0;
typeset p=0.0;
typeset theta2=0.0;
typeset phi2=0.0;

(( ii= i*10 ))
cd /home/davidcoeurjolly/Sources/digitalSnow/radiativeTransfer/tools/build/Data
mkdir $1:r
cd $1:r
echo $PWD


echo "===== Generating first PBRT files ===="
../../Noff2Pbrt -i ../../$file -o temp -t 0 -p 0 >! log

for theta in {0..0}
do
    (( theta2=theta*10 ))
    echo "=========== Theta $theta ==========="
    for phi in {0..8}
    do
        (( phi2=phi*10 ))
	echo "=========== Phi $phi ==========="
        (( t=theta2*PI/180.0))
        (( p=phi2*PI/180.0))
	echo "    Updating pbrt..."
	(( x= 50.0*cos(t)*sin(p) ))
	(( y= 50.0*sin(t)*sin(p) ))
	(( z= 50.0*cos(p) ))
	echo $x "--" $y "--" $z
	    
		    
	cat tempPhoton.pbrt  | head -n 10 >! temp_$theta2-$phi2-Photon.pbrt
	echo "LightSource \"distant\" \"point from\" [$x $y $z] \"point to\" [0 0 0]" >>  temp_$theta2-$phi2-Photon.pbrt
	cat tempPhoton.pbrt | tail -n +12 >>  temp_$theta2-$phi2-Photon.pbrt
       
	for lambda in {4..6}
	do
	    echo "=========== Lambda $lambda ==========="
	    echo "    Shooting..."
	    pbrt -p -w ${lambda}00 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
	    pbrt -p -w ${lambda}10 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
	    pbrt -p -w ${lambda}20 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
	    pbrt -p -w ${lambda}30 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
 	    pbrt -p -w ${lambda}40 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
	    pbrt -p -w ${lambda}50 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
	    pbrt -p -w ${lambda}60 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
	    pbrt -p -w ${lambda}70 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt &
	    pbrt -p -w ${lambda}80 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt & 	    
	    pbrt -p -w ${lambda}90 -x $sx -y $sy -z $sz -r $r -t $theta2 -phi $phi2 temp_$theta2-$phi2-Photon.pbrt 
	done
    done
done
