# BUILD INSTRUCTIONS
# ------------------

set -eu

PREV_PWD=$(readlink -f .)

# module purge
# module load gcc/14.2.0
# module load openmpi/5.0.7
# module load cmake intel/2025.2.0
# module list


# export MKLROOT=/vast/projects/ops/rocky9/intel/oneapi/mkl/latest/
export BLASROOT=/usr/lib/x86_64-linux-gnu/openblas-pthread
export TAMM_INSTALL_PATH=$HOME/local/install

if [ ! -d "$TAMM_INSTALL_PATH" ]; then
    set -x
    mkdir -p "$TAMM_INSTALL_PATH"
    set +x
else
    echo "TAMM_INSTALL_PATH exists ${TAMM_INSTALL_PATH}, skip mkdir."
fi

echo
echo "#### $(date +%FT%T)"
echo "#### Building TAMM first"
echo

#Build TAMM first
# git clone --depth 1 https://github.com/NWChemEx/TAMM.git
cd TAMM
mkdir build || echo "okay"
cd build
set -x
# CC=gcc CXX=g++ FC=gfortran cmake -DCMAKE_INSTALL_PREFIX=$TAMM_INSTALL_PATH/tamm \
#     -DCMAKE_BUILD_TYPE=Release ..  \
#     -DLINALG_VENDOR=IntelMKL \
#     -DLINALG_PREFIX=$MKLROOT  \
#     -DMODULES=CC
CC=gcc CXX=g++ FC=gfortran cmake -DCMAKE_INSTALL_PREFIX=$TAMM_INSTALL_PATH/tamm \
    -DLINALG_VENDOR=OpenBLAS \
    -DLINALG_PREFIX=$BLASROOT  \
    -DCMAKE_BUILD_TYPE=Release ..  \
    -DMODULES=CC
set +x
make -j4
make install

cd "$PREV_PWD"

echo
echo "#### $(date +%FT%T)"
echo "#### Building exachem"
echo

#Build exachem
#git clone https://github.com/ExaChem/exachem
# cd exachem-main
cd exachem
mkdir build || echo "okay"
cd build
set -x
CC=gcc CXX=g++ FC=gfortran cmake -DCMAKE_INSTALL_PREFIX=$TAMM_INSTALL_PATH/tamm \
    -DLINALG_VENDOR=OpenBLAS \
    -DLINALG_PREFIX=$BLASROOT  \
    -DCMAKE_BUILD_TYPE=Release ..  \
    -DMODULES=CC
set +x
make -j4
make install

cd "$PREV_PWD"

echo
echo "#### $(date +%FT%T)"
echo "#### Building all finished."
echo
