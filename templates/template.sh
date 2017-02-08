#PBS -N AAA
#PBS -q default
#PBS -l nodes=1:ppn=16,mem=10GB,walltime=6:00:00
#PBS -M piskuliche@ku.edu
#PBS -m abe
#PBS -S /bin/bash
#PBS -j oe


cd $PBS_O_WORKDIR
#Save job specific info for troubleshooting
echo "Job ID is ${PBS_JOBID}"
echo "Running on host ${hostname}"
echo "The following processors are allocated to this job"
echo $(cat $PBS_NODEFILE)



#Run the program
module load intel_compiler_2016
#module load mpich/3.0.4
module load gcc/5.3.0
module load lammps/20151207
module load intel_mpi_intel64
module load cuda/7.5
mpdboot
ulimit -s unlimited
ulimit -s
echo "Start: $(date +%F_%T)"
NSLOTS=16
time mpiexec.hydra -n $NSLOTS lmp_cpu <./AAA
echo "Stop: $(date +%F_%T)"


