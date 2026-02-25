OUTPUT_DIR="output.both.$(date +%FT%T)"

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

:> output.no_cxl.log
:> output.no_cxl.realtime.log
:> output.with_cxl.log
:> output.with_cxl.realtime.log

project_dir="/home/peng599/pppp/cxlmemsim_project/exachem_cxl_mem_server_eval"
exachem_dir="${project_dir}/exachem"
hostfiles_dir="${project_dir}/hostfiles"

repeat=10

# input_file="${exachem_dir}/inputs/ci/uracil.json"
input_file="${exachem_dir}/inputs/ci/uracil2.json"
# input_file="${exachem_dir}/inputs/ozone.json"

# hostfile="${hostfiles_dir}/hostfile"
# hostfile="${hostfiles_dir}/hostfile.2-nodes.16-ppn.config"
# hostfile="${hostfiles_dir}/hostfile.4-nodes.16-ppn.config"
# hostfile="${hostfiles_dir}/hostfile.8-nodes.16-ppn.config"
hostfile="${hostfiles_dir}/hostfile.localhost.16-ppn.config"


# Note:
# PMIX_MCA_gds=hash is used for more than 5 nodes
# Ref: https://github.com/mlcommons/storage/issues/176

for i in $(seq 1 $repeat); do

    ## No CXL
    set -x
    {
    /usr/bin/time -f "%e" \
    mpirun -np 2 --hostfile "${hostfile}" \
        "$HOME/local/install/tamm/bin/ExaChem" "$input_file"
    } 2>&1 | tee -a output.no_cxl.log
    tail -n 1 output.no_cxl.log >> output.no_cxl.realtime.log
    set +x

    rm -rf *_files

    ## With CXL
    set -x
    {
	CXL_DAX_PATH=/dev/dax0.1 \
	CXL_MEASURE_LATENCY=1 \
	LD_PRELOAD="/home/peng599/pppp/cxlmemsim_project/Splash/build/libmpi_cxl_numa_shim.so" \
    /usr/bin/time -f "%e" \
    mpirun -np 2 --hostfile "${hostfile}" \
        "$HOME/local/install/tamm/bin/ExaChem" "$input_file"
    } 2>&1 | tee -a output.with_cxl.log
    tail -n 1 output.with_cxl.log >> output.with_cxl.realtime.log
    set +x

    rm -rf *_files

done
