#!/bin/bash

# This portion of the energy fluctuations code actually calculates the mean square displacements of each configuration.

# Read In Parameters
STARTCONFIG=$1
ENDCONFIG=$2
SEP=$3

# System Information - Must Change this for DIFFERENT systems
NCOMP=1 #Number of Components
DUMPFREQ=50 #Frequency of dumps in lammps
START=0 #What the starting timestep to use is. (Should likely be 0)
END=20000 #What the ending timestep to use is. (Should likely be 20000)
NCORR=$((END/DUMPFREQ)) # Calculates the unitless length of each simulation
NSKIP=$END # Calculates the number to skip (should just be the same as end)
NBIN=1 # Number of bins for block averaging (should just be one)
DELIM=$ENDCONFIG # Adds a delimeter to the file. 
NSPEC=832 # Number of molecules of the particular species.
SPECTYPE=3 # Type of the species 1=EO 2=MeOH 3=CO2
BOXL=40 # Box Size
FNAME=config_out.dat # End filename for the configuration run

for ((j=$STARTCONFIG; j<=$ENDCONFIG; j++));
do
    # Specifies the value of the configuration
    VAL=$((j*SEPARATION))
    # Copies stuff into the folder, makes a replacement, moves into the folder.
    cp templates/tmp.txt $j/
    cp templates/tspt_template.sh tspt.$VAL.sh
    sed -i -e "s@AAA@tspt_$VAL@g" tspt.$VAL.sh
    mv tspt.$VAL.sh $j/
    # Changes directory into the folder, submits the transport calculation, changes directory back out again.
    cd $j
    msub tspt.$VAL.sh
    cd ..
done

# END PROGRAM
