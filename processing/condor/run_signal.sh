#!/bin/tcsh

echo PWD $PWD
ls .

echo setting up CMSSW
source /cvmfs/cms.cern.ch/cmsset_default.csh
setenv SCRAM_ARCH slc6_amd64_gcc493
eval `scramv1 project CMSSW CMSSW_7_6_5`
cd CMSSW_7_6_5/src/
eval `scramv1 runtime -csh` # cmsenv is an alias not on the workers
echo "CMSSW: "$CMSSW_BASE

echo setting library path
setenv LD_LIBRARY_PATH ${PWD}:${LD_LIBRARY_PATH}
echo LD_LIBRARY_PATH $LD_LIBRARY_PATH

echo copying libraries
xrdcp root://cmseos.fnal.gov//store/user/lpcsusyhad/BoostedTop/Libraries/mylibs.tar .
tar xvf mylibs.tar

echo move executable
cp ${_CONDOR_SCRATCH_DIR}/anaSubstructure .

echo "check ldd"
ldd anaSubstructure

echo copy input file
xrdcp root://cmseos.fnal.gov//store/user/lpcsusyhad/BoostedTop/Signals/$1 .

echo ls -lh .
ls -lh .

echo Start running
./anaSubstructure $1 ./ 0 10000 ""

echo move output
mv processed*.root ${_CONDOR_SCRATCH_DIR}

echo done
