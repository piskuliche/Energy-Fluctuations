#MSUB -N AAA
#MSUB -q default
#MSUB -l nodes=1:ppn=1,mem=10GB,walltime=6:00:00
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


module load legacy
module load intel_compiler_2016
module load gcc/5.3.0
echo "Start: $(date +%F_%T)"
time autocorrelation.exe > autocorr.out
echo "Stop: $(date +%F_%T)"


