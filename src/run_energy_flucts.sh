#!/bin/bash

#This subroutine reads in the starting and ending configuration number and then the separation of the configurations.

#The output of the routine is a series of jobs that actually creates a new series of runs by copying files from the NVT simulation results.
#The routine then actually submits the job to the Torque engine - as a series of linear batch jobs.

#This script should be run second in the overall Energy Fluctuations 

STARTCONFIG=$1
ENDCONFIG=$2
SEPARATION=$3
PREFIX=$4

for ((i=$STARTCONFIG;i<=$ENDCONFIG;i++))
do
    # Make a directory for the configuration
    mkdir $i
    # Calculate the timestep of the configuration (starting)
    VAL=$((i*SEPARATION))
    # Grab Everything but the header of the data file and the velocity file -> store them in tmp_dat.dat and tmp_vel.vel
    tail -n+10 ../DataFiles/$PREFIX.$VAL.dat > tmp_dat.dat
    tail -n+10 ../Velocity/$PREFIX.$VAL.vel > tmp_vel.vel
    sed -n '/Atoms/!p;//q' ../$PREFIX.data > lammps_header.txt
    echo '\nVelocities\n\n' > lammps_vel.txt
    sed -n '/Bonds/,$p' ../$PREFIX.data > bondsandangles.txt
    # Combines the lammps_header.txt tmp_dat.dat lammps_vel.txt tmp_vel.vel and bondsandangles.txt into a new data file.
    cat lammps_header.txt tmp_dat.dat lammps_vel.txt tmp_vel.vel bondsandangles.txt > init_config.$VAL.dat
    # Cleans up and moves stuff into the right directories.
    mv init_config.$VAL.dat $i/
    rm tmp_dat.dat tmp_vel.vel
    # Copies the template input file and submit script into a new file, modifies them, and then moves them into their respective folder.
    cp templates/template.inp config.$VAL.inp
    cp templates/template.sh config.$VAL.sh
    sed -i -e "s@AAA@init_config.$VAL.dat@g" config.$VAL.inp
    sed -i -e "s@AAA@config.$VAL.inp@g" config.$VAL.sh
    mv config.$VAL.* $i/
    # Changes directory to the config folder, submits the job, then changes directory back to main directory.
    cd $i
    msub config.$VAL.sh
    cd ..
done

# END ROUTINE
