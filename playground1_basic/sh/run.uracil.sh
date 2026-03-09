OUTPUT_DIR="output.$(date +%FT%T)"

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

:> output.no_cxl.log
:> output.no_cxl.realtime.log
:> output.with_cxl.log
:> output.with_cxl.realtime.log

repeat=1
# input_file="/home/exouser/pppp/project_exachem/exachem/inputs/ci/uracil.json"
input_file="/home/exouser/pppp/project_exachem/exachem/inputs/ci/uracil2.json"
# input_file="/home/exouser/pppp/project_exachem/exachem/inputs/ozone.json"

# hostfile="/home/exouser/pppp/project_exachem/hostfiles/hostfile"
# hostfile="/home/exouser/pppp/project_exachem/hostfiles/hostfile.2-nodes.16-ppn.config"
# hostfile="/home/exouser/pppp/project_exachem/hostfiles/hostfile.4-nodes.16-ppn.config"
hostfile="/home/exouser/pppp/project_exachem/hostfiles/hostfile.8-nodes.16-ppn.config"


# Note:
# PMIX_MCA_gds=hash is used for more than 5 nodes
# Ref: https://github.com/mlcommons/storage/issues/176

for i in $(seq 1 $repeat); do
    # bash ../../scripts/run_cross_instances.no_cxl.sh 2>&1 | tee -a output.no_cxl.log
    # bash ../../scripts/run_cross_instances.sh 2>&1 | tee -a output.with_cxl.log

    # ## No CXL
    set -x
    {
    /usr/bin/time -f "%e" \
    mpirun -np 128 --hostfile "$hostfile" \
        -mca btl_tcp_if_include enp1s0 \
        -mca oob_tcp_if_include enp1s0 \
        -x PMIX_MCA_gds=hash \
        /home/exouser/local/install/tamm/bin/ExaChem "$input_file"
    } 2>&1 | tee -a output.no_cxl.log
    tail -n 1 output.no_cxl.log >> output.no_cxl.realtime.log
    set +x

    rm -rf *_files

    ## With CXL
    set -x
    {
    /usr/bin/time -f "%e" \
    mpirun -np 128 --hostfile "$hostfile" \
        -mca btl_tcp_if_include enp1s0 \
        -mca oob_tcp_if_include enp1s0 \
        -x PMIX_MCA_gds=hash \
        -x CXL_MEMSIM_HOST=127.0.0.1 \
        -x CXL_MEMSIM_PORT=9999 \
        -x CXL_NUM_NODES=8 \
        -x CXL_SIZE=2147483648 \
        -x LD_PRELOAD=/home/exouser/pppp/OCEAN-private/build/libmpi_cxlmemsim_shim.so \
        /home/exouser/local/install/tamm/bin/ExaChem "$input_file"
    } 2>&1 | tee -a output.with_cxl.log
    tail -n 1 output.with_cxl.log >> output.with_cxl.realtime.log
    set +x

    rm -rf *_files

done
