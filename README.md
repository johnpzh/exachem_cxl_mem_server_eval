# Evaluating ExaChem on CXL Emulation

## Set up ExaChem

Clone ExaChem
```bash
git submodule update --init --recursive --depth 1
```

Probablly need to install OpenBLAS first
```bash
sudo apt install -y libopenblas-dev libgslcblas0 libgsl-dev liblapacke liblapacke-dev liblapack-dev
```

Then, run the script to build `TAMM` and `ExaChem`
```bash
bash scripts/build.sh
```

If it succeeds, congratulations! You have built `TAMM` and `ExaChem` successfully, and their binaries are installed to `~/local/install/tamm/bin`.

However, if it fails, complaining something like this
```
The dependency target "BLAS_External" of target "GlobalArrays_External" does not exist.
```
Then, we need to try something else as follows.

Change the `TAMM/CMakeLists.txt` (there is probably a bug in TAMM's build scripts). Change
```cmake
list(APPEND TAMM_DEPENDENCIES GlobalArrays) #BLAS LAPACK
```
to
```cmake
list(APPEND TAMM_DEPENDENCIES BLAS LAPACK GlobalArrays) #BLAS LAPACK
```
to enable `BLAS` and `LAPACK`.

Run the script to build `TAMM` and `ExaChem`
```bash
bash scripts/build.sh
```

Surprisingly, the build will fail again, complaining something like this
```
get_property could not find TARGET BLAS_External.  Perhaps it has not yet been created.
```

Now, change the `TAMM/CMakeLists.txt` back to the original version, i.e., to
```cmake
list(APPEND TAMM_DEPENDENCIES GlobalArrays) #BLAS LAPACK
```
then run the `bash scripts/build.sh` again. Hooray!
