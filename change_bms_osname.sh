#/bin/bash
oldname[1]=Linux_RHEL8-x86_64-gcc8.5.0
newname[1]=Linux_RHEL8-gcc8.5
oldname[2]=Linux_RHEL7-x86_64-gcc4.8.5
newname[2]=Linux_RHEL7-gcc4.8
oldname[3]=Linux_CentOS7-x86_64-gcc4.8.5-cntr
newname[3]=Linux_CentOS7-gcc4.8

pwd=`pwd`
echo working in $pwd
bn=`basename $pwd`
if [ "$bn" != "builds" ]
then
    echo not working in builds, exiting
    exit 1
fi
for i in {1..3}
do

    # create gluex_top directories for the new names
    mkdir -v ${newname[$i]}

    # make package directories under gluex_top's for the new names
    find ${oldname[$i]} -maxdepth 1 -mindepth 1 -type d \
	| awk -v newname="${newname[$i]}" -F${oldname[$i]}/ \
	      '{ print "mkdir -v ./"newname"/"$2 }' | bash
    
    # create soft links to the built package directories pointing from
    # the new name directories to the old name directories
    find ${oldname[$i]} -maxdepth 2 -mindepth 2 \
	| awk -v newname="${newname[$i]}" -F/ \
	      {'print "ln -sv ../../"$0" "newname"/"$2"/"$3'} | bash

    # create soft links parallel to BMS_OSNAME'd subdirectories under
    # the old-named package directorys with new names pointing to the
    # old names
    find  ${oldname[$i]} -maxdepth 3 -mindepth 3 -name ${oldname[$i]} \
	| awk -F/ -v newname="${newname[$i]}" -v oldname="${oldname[$i]}" \
	      '{print "ln -sv "oldname" "oldname"/"$2"/"$3"/"newname}' | bash

done

# command to make a test directory
# find /group/halld/Software/builds -maxdepth 4 -type d | awk -F'/builds/' '{print "mkdir -pv builds/"$2}' | bash
