set -eu

OUTPUT_DIR="output.$(date +%FT%T)"

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

:> output.with_cxl.log

repeat=1

# mpirun -np 4 --oversubscribe \
# -x CXL_MEMSIM_HOST=127.0.0.1 \
# -x CXL_MEMSIM_PORT=9999 \
# -x CXL_NUM_NODES=2 \
# -x CXL_SIZE=1073741824 \
# -x LD_PRELOAD=/home/exouser/pppp/OCEAN-private/build/libmpi_cxlmemsim_shim.so \
# /home/exouser/pppp/tests/mpi_test/hello_mpi

# mpirun -np 4 --hostfile hostfiles/hostfile \
# -x CXL_MEMSIM_HOST=127.0.0.1 \
# -x CXL_MEMSIM_PORT=9999 \
# -x CXL_NUM_NODES=2 \
# -x CXL_SIZE=1073741824 \
# -x LD_PRELOAD=/home/exouser/pppp/OCEAN-private/build/libmpi_cxlmemsim_shim.so \
# /home/exouser/pppp/tests/mpi_test/hello_mpi

input_file="/home/exouser/pppp/project_exachem/exachem/inputs/ozone.json"
# input_file="/home/exouser/pppp/project_exachem/exachem/inputs/ci/uracil.json"

set -x
{
/usr/bin/time -f "%e" \
mpirun -np 2 \
        -mca btl_tcp_if_include enp1s0 \
        -mca oob_tcp_if_include enp1s0 \
        -x CXL_MEMSIM_HOST=127.0.0.1 \
        -x CXL_MEMSIM_PORT=9999 \
        -x CXL_NUM_NODES=2 \
        -x CXL_SIZE=2147483648 \
        -x LD_PRELOAD=/home/exouser/pppp/OCEAN-private/build/libmpi_cxlmemsim_shim.so \
    /home/exouser/local/install/tamm/bin/ExaChem "$input_file"
} 2>&1 | tee -a output.with_cxl.log
set +x
