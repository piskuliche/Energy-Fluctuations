#MSUB -N AAA
#MSUB -q default
#MSUB -l nodes=1:ppn=16,mem=10GB,walltime=6:00:00
#MSUB -M piskuliche@ku.edu
#MSUB -m abe
#MSUB -S /bin/bash
#MSUB -j oe
#MSUB -d ./

cd $PBS_O_WORKDIR
#Save job specific info for troubleshooting
echo "Job ID is ${PBS_JOBID}"
echo "Running on host ${hostname}"
echo "The following processors are allocated to this job"
echo $(cat $PBS_NODEFILE)


#Run the program
module load legacy
#module load mpich/3.0.4
module load lammps/20151207
echo "Start: $(date +%F_%T)"
NSLOTS=16
time mpiexec.hydra -n $NSLOTS lmp_cpu <./AAA
echo "Stop: $(date +%F_%T)"


