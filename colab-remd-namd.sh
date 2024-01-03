nvidia-cuda-mps-control -d
export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
ssh -O StrictHostKeyChecking=No
mpirun /content/namdgpu2/namd3 +replicas 2 +p4 +devices 0 job0.conf +stdout output/%d/alanin.%d.log 
#-o StrictHostKeyChecking=no
