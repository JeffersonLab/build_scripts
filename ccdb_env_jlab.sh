use -s python 27
version=0.05
osrelease=`/group/halld/Software/scripts/build_scripts/osrelease.pl`
export CCDB_HOME=/group/halld/Software/builds/ccdb/$osrelease/ccdb_$version
source $CCDB_HOME/environment.bash
export CCDB_CONNECTION=mysql://ccdb_user@halldweb1/ccdb