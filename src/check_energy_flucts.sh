#!/bin/bash

#This script should be used for checking energy fluctuations of MD simulations
#It is intended to grab a series of log.lammps files, and pull out the initial energies from each file.

#User Interface: CONFIGS holds # of configurations, SEP holds separation of timesteps in fs
STARTCONFIG=$1
ENDCONFIG=$2
SEPARATION=$3

#For Loop Through All Configurations
rm initial_energy.dat MSD.dat
touch initial_energy.dat
for ((i=$STARTCONFIG; i<=$ENDCONFIG; i++));
do
    awk '/Step Time TotEng PotEng KinEng Temp Press Volume Pxx Pyy Pzz Pxy Pxz Pyz/{getline; print $3}' $i/log.lammps >> initial_energy.dat
done

