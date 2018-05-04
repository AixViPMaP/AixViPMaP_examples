#!/bin/bash

WD="$PWD"
ext="$WD/usr/"
CONDOR_EXEC="$(condor_config_val LIBEXEC)"

probe_env() {
    echo "Running on $(hostname) as user $(whoami)"
    echo "Shell=${SHELL}"
    [ -d "${ext}"  ] || echo "${ext} doesn't exist!"
    DM_test.exe -h &> /dev/null
}

sync_files() {
    while true; do
        sleep 10
        (
          cd "$WD" &&
          find . -name '*.txt' -exec "$CONDOR_EXEC/condor_chirp" put '{}' '{}' \;
        )
    done
}

run_OP() {
    set -e
    cd "$WD/OP"
    module load intel gcc fftw
    Al3Li_Benchmark.exe 2> stderr-op.txt 1> stdout-op.txt
}

run_DAMASK() {
    set -e
    cd "$WD/DAMASK"
    export DAMASK_NUM_THREADS=3
    module load intel fftw
    DM_test.exe --geom s32.geom --load *.load 2> stderr-dm.txt 1> stdout-dm.txt
}

source /opt/sw/etc/bashrc &> /dev/null
module load intel

ulimit -c 0
ulimit -s unlimited

export LD_LIBRARY_PATH="${ext}/lib64/:${LD_LIBRARY_PATH}"
export PATH="${ext}/bin/:${PATH}"
export SHMEM_NAME="libCPPF_AlLiBM_$(date +%s)_$(( ( RANDOM % 10000 )  + 1 ))"

chmod u+x "${ext}"/*/
chmod u+x "${ext}"/bin/*.exe

probe_env || exit 8

sync_files &
run_OP &
run_DAMASK

