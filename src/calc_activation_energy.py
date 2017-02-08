#!/usr/bin/env python

# This program is designed to calculate the activation energy in the manner of the energy fluctuations method
# This program was designed by Ezekiel Piskulich in December 2016 at the University of Kansas

# This program may be used in the following manner:
# python calc_activation_energy.py -ns STARTCONFIG -ne ENDCONFIG -m #MOLECS

# Import Statements
import numpy as np
import argparse
import math
import itertools as IT
from argparse import RawTextHelpFormatter,SUPPRESS

#Argument Parser, Allows User Interface
parser = argparse.ArgumentParser(description='''For the energy fluctuations method, this program calculates the activation energy of diffusion.''', formatter_class=RawTextHelpFormatter)
parser.add_argument('-ns', help="Starting Configuration")
parser.add_argument('-ne', help="Ending Configuration")
parser.add_argument('-m', help="Number of Molecs")
args = parser.parse_args()
nstart=int(args.ns)
nfiles=int(args.ne)
nmolecs=int(args.m)
vals = None
hvals= None

#Calculates The Average Initial Energy
hzero = np.genfromtxt("initial_energy.dat", dtype=None, usecols=(0,))
hsum=0
hav=0
n=0
for item in hzero:
    hsum+=item
    n+=1
hav=hsum/n

# Loop over each of the configurations, weighting by the energy fluctuations dH(0)=(H(0)-<H>)
for n in range(nstart,nfiles+1,1):
    filepath=str(n)+"/msd_500_bin_0.dat"
    arr = np.genfromtxt(filepath, dtype=None, usecols=(1,))
    if vals is None:
        vals = arr
        hvals=arr*(hzero[n-nstart]-hav) # (H(0)-<H>)*|r(t)-r(0)|^2
    else:
        vals += arr
        hvals += arr*(hzero[n-nstart]-hav)

# conducts the average <dH(0)|r(t)-r(0)|^2> and <|r(t)-r(0)|^2>
meanvals = vals / nfiles
meanhvals = hvals / (nfiles)

# Divides the above two averages to get the activation energy
eavals = meanhvals/meanvals

# Formats the output files
out = open('ea_out.dat', 'w') # Activation Energy
out2 = open('dhmsd_out.dat', 'w') # hzero * MSD
out3 = open('eflucs_out.dat','w') # Fluctuations in Energy around 0 i.e. dH(0)
out4 = open('msd_out.dat', 'w') # MSD
m=0
for item in eavals:
    m=m+50
    out.write("%s %s\n" % (m,item))
m=0
for item in meanhvals:
    m=m+50
    out2.write("%s %s\n" % (m,item))
m=0
for item in meanvals:
    m=m+50
    out4.write("%s %s\n" % (m,item))
for item in hzero:
    eflucs=item-hav
    out3.write("%s\n" % eflucs)
