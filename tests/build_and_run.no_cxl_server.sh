set -eux
mpicxx -o hello_mpi hello_mpi.cpp
set +x

CURR_DIR=$(readlink -f .)

set -x
mpirun -np 2 \
    --hostfile hostfile.slots1 \
    hello_mpi
set +x
