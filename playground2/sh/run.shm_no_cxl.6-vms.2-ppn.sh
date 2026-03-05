set -eu

OUTPUT_DIR="output.shm_no_cxl.6-vms.2-ppn.$(date +%FT%T)"

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

:> output.no_cxl.log
:> output.no_cxl.realtime.log

repeat=3

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
    mpirun --allow-run-as-root -np 12 --map-by ppr:2:node --oversubscribe --hostfile ../hostfile \
        "/root/mnt/shared/install/tamm/bin/ExaChem" "$input_file"
    } 2>&1 | tee -a output.no_cxl.log
    tail -n 1 output.no_cxl.log >> output.no_cxl.realtime.log
    set +x

    rm -rf *_files

done

rm -rf /dev/shm/*