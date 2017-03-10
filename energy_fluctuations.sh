#!/bin/bash

#This is the main program file for the Energy Fluctuations Code.


# USER INPUT
STARTCONFIG=$1
ENDCONFIG=$2
SEPARATION=$3
PREFIX=$4


# START PROGRAM
echo -e "***********************"
echo -e "**ENERGY FLUCTUATIONS**"
echo -e "***********************"

echo -e "Please enter the step of the Energy Fluctuations Calculation.\n"
echo -e "  [1] Run the simulations\n"
echo -e "  [2] Check the Initial Energies\n"
echo -e "  [3] Run the Transport Calculations\n"
echo -e "  [4] Calculate the Activation Energies\n"
read STEP

# First Step: Run the Simulations:
if   (( "$STEP" == "1" )); then
    echo -e "Running the Simulations."
    cp src/run_energy_flucts.sh ./
    chmod 777 run_energy_flucts.sh
    ./run_energy_flucts.sh $STARTCONFIG $ENDCONFIG $SEPARATION $PREFIX
    rm run_energy_flucts.sh
# Second Step: Calculate the Initial Energies
elif (( "$STEP" == "2" )); then
    echo -e "Checking the Initial Energies"
    cp src/check_energy_flucts.sh ./
    chmod 777 check_energy_flucts.sh
    ./check_energy_flucts.sh $STARTCONFIG $ENDCONFIG $SEPARATION
    rm check_energy_flucts.sh
# Third Step: Run The Transport Calculations
elif (( "$STEP" == "3" )); then
    echo -e "Running the Transport Calculations"
    cp src/tspt_pure_energy_flucts.sh ./
    chmod 777 tspt_pure_energy_flucts.sh
    ./tspt_pure_energy_flucts.sh $STARTCONFIG $ENDCONFIG $SEPARATION
    rm tspt_pure_energy_flucts.sh
# Fourth Step: Calculate Activation Energies
elif (( "$STEP" == "4" )); then
    echo -e "Calculating the Activation Energies"
    cp src/calc_activation_energy.py ./
    python calc_activation_energy.py -ns $STARTCONFIG -nf $ENDCONFIG -s $SEPARATION
    rm calc_activation_energy.py
else 
    echo -e "Invalid Option - Please Try Again"
fi

echo -e "The Energy Fluctuations Code has Completed.\n"
echo -e "*********************************************\n"


