OUTPUT_DIR="output.$(date +%FT%T)"

mkdir -p "$OUTPUT_DIR"

cd "$OUTPUT_DIR"

:> output.no_cxl.log
:> output.with_cxl.log

repeat=3

for i in $(seq 1 $repeat); do
    bash ../../scripts/run_cross_instances.no_cxl.sh 2>&1 | tee -a output.no_cxl.log
    bash ../../scripts/run_cross_instances.sh 2>&1 | tee -a output.with_cxl.log
done
