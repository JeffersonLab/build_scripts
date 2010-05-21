#!/bin/tcsh -f

set NEVENTS=1000
set VERTEX="0 0 50 80"  # x y zmin zmax
set NTHREADS=Ncores
set b1pi_input=${HALLD_HOME}/src/programs/Simulation/genr8/InputFiles/b1_pi.input

if ( ! -e ${b1pi_input} ) then
	echo " "
	echo "No file: ${b1pi_input}"
	echo "Please make sure your HALLD_HOME env. var. is set."
	echo " "
	exit -1
endif

echo "Copying ${b1pi_input} ..."
cp $b1pi_input b1_pi.input

echo "Running genr8 ..."
genr8 -M${NEVENTS} -Ab1_pi.ascii < b1_pi.input >& /dev/null

echo "Converting generated events to HDDM ..."
genr8_2_hddm -V${VERTEX} b1_pi.ascii  >& /dev/null
mv output.hddm b1_pi.hddm

echo "Creating control.in file ..."
cat - << EOF > control.in

INFILE 'b1_pi.hddm'
TRIG ${NEVENTS}
OUTFILE 'hdgeant.hddm'
RNDM 123
HADR 0

EOF

echo "Running hdgeant ..."
hdgeant

echo "Running mcsmear ..."
mcsmear hdgeant.hddm

echo "Running hd_root ..."
hd_root -PNTHREADS=${NTHREADS} -PPLUGINS=phys_tree hdgeant_smeared.hddm
 

