OUTPUT_DIR="output.$(date +%FT%T)"

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

:> output.no_cxl.log
:> output.with_cxl.log

repeat=1
input_file="/home/exouser/pppp/project_exachem/exachem/inputs/ci/uracil.json"
# input_file="/home/exouser/pppp/project_exachem/exachem/inputs/ozone.json"

for i in $(seq 1 $repeat); do
    # bash ../../scripts/run_cross_instances.no_cxl.sh 2>&1 | tee -a output.no_cxl.log
    # bash ../../scripts/run_cross_instances.sh 2>&1 | tee -a output.with_cxl.log

    ## No CXL
    set -x
    {
    time \
    mpirun -np 4 --hostfile /home/exouser/pppp/project_exachem/hostfiles/hostfile \
        -mca btl_tcp_if_include enp1s0 \
        -mca oob_tcp_if_include enp1s0 \
        /home/exouser/local/install/tamm/bin/ExaChem "$input_file"
    } 2>&1 | tee -a output.no_cxl.log
    set +x

    ## With CXL
    set -x
    {
    time \
    mpirun -np 4 --hostfile /home/exouser/pppp/project_exachem/hostfiles/hostfile \
        -mca btl_tcp_if_include enp1s0 \
        -mca oob_tcp_if_include enp1s0 \
        -x CXL_MEMSIM_HOST=127.0.0.1 \
        -x CXL_MEMSIM_PORT=9999 \
        -x CXL_NUM_NODES=2 \
        -x CXL_SIZE=21474836480 \
        -x LD_PRELOAD=/home/exouser/pppp/OCEAN-private/build/libmpi_cxlmemsim_shim.so \
        /home/exouser/local/install/tamm/bin/ExaChem "$input_file"
    } 2>&1 | tee -a output.with_cxl.log
    set +x

done
