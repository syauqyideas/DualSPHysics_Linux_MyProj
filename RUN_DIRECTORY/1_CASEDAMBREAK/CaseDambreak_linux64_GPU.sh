#!/bin/bash


# "name" and "dirout" are named according to the testcase

name=CaseDambreak
dirout=${name}_out
dirfluid=$dirout/fluid

# "executables" are renamed and called from their directory

gencase="../../EXECS/GenCase4_linux64"
dualsphysics="../../EXECS/DualSPHysics4_linux64"
boundaryvtk="../../EXECS/BoundaryVTK4_linux64"
partvtk="../../EXECS/PartVTK4_linux64"
partvtkout="../../EXECS/PartVTKOut4_linux64"
measuretool="../../EXECS/MeasureTool4_linux64"
computeforces="../../EXECS/ComputeForces4_linux64"


# Library path must be indicated properly

current=$(pwd)
cd ../../EXECS
path_so=$(pwd)
cd $current
export LD_LIBRARY_PATH=$path_so


# "dirout" is created to store results or it is cleaned if it already exists

if [ -e $dirout ]; then
  rm -f -r $dirout
fi
mkdir $dirout


# CODES are executed according the selected parameters of execution in this testcase
errcode=0

if [ $errcode -eq 0 ]; then
  $gencase ${name}_Def $dirout/$name -save:all
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $dualsphysics $dirout/$name $dirout -svres -gpu
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtk -dirin $dirout -savevtk $dirout/PartFluid -onlytype:-all,+fluid
  errcode=$?
fi

if [ $errcode -eq 0 ]; then
  $partvtkout -dirin $dirout -filexml $dirout/${name}.xml -savevtk $dirout/PartFluidOut -SaveResume $dirfluid
  errcode=$?
fi

#if [ $errcode -eq 0 ]; then
#  $measuretool -dirin $dirout -points CaseDambreak_PointsVelocity.txt -onlytype:-all,+fluid -vars:-all,+vel -savevtk $dirout/PointsVelocity -savecsv $dirout/PointsVelocity
#  errcode=$?
#fi

#if [ $errcode -eq 0 ]; then
# $measuretool -dirin $dirout -points CaseDambreak_PointsPressure_Incorrect.txt -onlytype:-all,+fluid -vars:-all,+press,+kcorr -kcusedummy:0 -kclimit:0.5 -savevtk $dirout/PointsPressure_Incorrect -savecsv $dirout/PointsPressure_Incorrect
#  errcode=$?
#fi

#if [ $errcode -eq 0 ]; then
#  $measuretool -dirin $dirout -points CaseDambreak_PointsPressure_Correct.txt -onlytype:-all,+fluid -vars:-all,+press,+kcorr -kcusedummy:0 -kclimit:0.5 -savevtk $dirout/PointsPressure_Correct -savecsv $dirout/PointsPressure_Correct
#  errcode=$?
#fi

#if [ $errcode -eq 0 ]; then
#  $computeforces -dirin $dirout -filexml $dirout/${name}.xml -onlymk:21 -savecsv $dirout/WallForce
#  errcode=$?
#fi



if [ $errcode -eq 0 ]; then
  echo All done
else
  echo Execution aborted
fi
echo execution exited
exit 1
