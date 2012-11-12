use python 27
set version=0.05
set osrelease=`/group/halld/Software/scripts/build_scripts/osrelease.pl`
setenv CCDB_HOME /group/halld/Software/builds/ccdb/$osrelease/ccdb_$version
source $CCDB_HOME/environment.csh
