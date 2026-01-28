set -eux
mpicxx -o hello_mpi hello_mpi.cpp
set +x

set -x
# mpirun -np 4 --oversubscribe \
# -x CXL_MEMSIM_HOST=127.0.0.1 \
# -x CXL_MEMSIM_PORT=9999 \
# -x CXL_NUM_NODES=2 \
# -x CXL_SIZE=1073741824 \
# -x LD_PRELOAD=/home/exouser/pppp/OCEAN-private/build/libmpi_cxlmemsim_shim.so \
# /home/exouser/pppp/tests/mpi_test/hello_mpi
mpirun -np 4 --hostfile hostfile \
-x CXL_MEMSIM_HOST=127.0.0.1 \
-x CXL_MEMSIM_PORT=9999 \
-x CXL_NUM_NODES=2 \
-x CXL_SIZE=1073741824 \
-x LD_PRELOAD=/home/exouser/pppp/OCEAN-private/build/libmpi_cxlmemsim_shim.so \
/home/exouser/pppp/tests/mpi_test/hello_mpi
set +x
