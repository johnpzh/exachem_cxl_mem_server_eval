set -eu

OUTPUT_DIR="output.shm_with_cxl.1-vms.2-ppn.$(date +%FT%T)"

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

:> output.with_cxl.log
:> output.with_cxl.realtime.log

repeat=10

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

# input_file="/root/data/ozone.json"
# input_file="/root/data/uracil2.json"
# input_file="/root/data/uracil3.json"
# input_file="/root/data/uracil4.json"
input_file="/root/data/uracil5.json"

for i in $(seq 1 $repeat); do

    set -x
    {
    /usr/bin/time -f "%e" \
    mpirun --allow-run-as-root -np 2 --oversubscribe \
        -x CXL_DAX_PATH=/dev/dax0.0 \
	    -x LD_PRELOAD=/root/libmpi_cxl_shim.so \
        "/root/mnt/shared/install/tamm/bin/ExaChem" "$input_file"
    } 2>&1 | tee -a output.with_cxl.log
    tail -n 1 output.with_cxl.log >> output.with_cxl.realtime.log
    set +x

    rm -rf *_files

done

rm -rf /dev/shm/*