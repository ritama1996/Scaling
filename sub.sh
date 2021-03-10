#!/bin/bash
#PBS -N mtace-32
#PBS -q large
#PBS -l nodes=12:ppn=20
#PBS -j oe
export I_MPI_FABRICS=shm:tmi
export I_MPI_DEVICE=rdma:OpenIB-cma
cd $PBS_O_WORKDIR
cat $PBS_NODEFILE > pbs_nodes
export I_MPI_MPD_TMPDIR=/scratch/kritama
export F_UFMTENDIAN=big
#source /opt/software/intel/initpaths intel64
source /opt/software/intel_2019.u0/initpaths intel64


INPUT=job.in
# Change the directory according to the method (MTACE/s-MTACE)
CPMDEXE=/home/kritama/CPMD_CODES/CPMD_MTS_ACE_GLE_IN_WFN_WTMTD/bin/cpmd.x

PPDIR=/home/kritama/PP_AC/PP

OUTPUT=out_new

set -vx

for i in `seq 240 -20 20`

do 

mkdir ncpu_$i

cp job.in LATEST RESTART* ncpu_$i/
cd ncpu_$i/
mpirun -machinefile $PBS_NODEFILE -n $i $CPMDEXE  $INPUT $PPDIR > $OUTPUT

cd ../


done

