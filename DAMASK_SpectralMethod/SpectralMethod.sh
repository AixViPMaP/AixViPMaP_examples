#!/bin/bash
#
# This script implements the *SpectalMethod* example described in full detail
# on the official DAMASK website in order to illustrate how to use our Docker
# image *docker-vtk*.
#
# DAMASK *SpectalMethod* example
# https://damask.mpie.de/Usage/SpectralSolver

########################################
# Init
########################################

# Load environment
source /env.sh

# Exit immediately if a command exits with a non-zero status
set -e

# Copy SpectalMethod example to working directory
cp -r $DAMASK_DIR/examples/SpectralMethod .
cd SpectralMethod

########################################
# DAMASK SpectalMethod example
########################################

DAMASK_spectral --load tensionX.load --geom 20grains16x16x16.geom

postResults --cr f,p --split --separation x,y,z \
20grains16x16x16_tensionX.spectralOut

cd postProc
showTable -a 20grains16x16x16_tensionX_inc100.txt

addCauchy 20grains16x16x16_tensionX_inc100.txt
addMises -s Cauchy 20grains16x16x16_tensionX_inc100.txt
showTable -a 20grains16x16x16_tensionX_inc100.txt

addStrainTensors --left --logarithmic 20grains16x16x16_tensionX_inc100.txt
addMises -e 'ln(V)' 20grains16x16x16_tensionX_inc100.txt
showTable -a 20grains16x16x16_tensionX_inc100.txt

vtk_rectilinearGrid 20grains16x16x16_tensionX_inc100.txt
vtk_addRectilinearGridData \
--inplace \
--scalar 'Mises(Cauchy)',1_p,'1_ln(V)',1_Cauchy \
--vtk '20grains16x16x16_tensionX_inc100_pos(cell).vtr' \
20grains16x16x16_tensionX_inc100.txt
