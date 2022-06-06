#/bin/bash

print_usage() {
    cat <<+
usage: change_bms_osname.sh <target>
    
where target is one of

  "jlab": convert the /group/halld/Software/builds tree at JLab (script must be
          executed from a directory named "builds")
  "gluex_top": convert a GLUEX_TOP tree (GLUEX_TOP must be defined in the
	       environment)
  "halld_my": convert a HALLD_MY tree (HALLD_MY must be defined in the
              environment)
  "jana": convert a jana tree (JANA_HOME must be defined in the environment)
  "hdds": convert a hdds tree (HDDS_HOME must be defined in the environment)
  "halld_recon": convert a halld_recon tree (HALLD_RECON_HOME must be defined in
		 the environment)
  "halld_sim": convert a halld_sim tree (HALLD_SIM_HOME must be defined in the
	       environment)
  "gluex_root_analysis": convert a gluex_root_analysis tree (ROOT_ANALYSIS_HOME
			 must be defined in the environment)
+
}

oldname[1]=Linux_RHEL8-x86_64-gcc8.5.0
newname[1]=Linux_RHEL8-x86_64-gcc8.5
oldname[2]=Linux_CentOS7-x86_64-gcc4.8.5-cntr
newname[2]=Linux_CentOS7-x86_64-gcc4.8
oldname[3]=Linux_CentOS7.7-x86_64-gcc4.8.5
newname[3]=Linux_CentOS7-x86_64-gcc4.8
oldname[4]=Linux_RHEL7-x86_64-gcc4.8.5
newname[4]=Linux_RHEL7-x86_64-gcc4.8
oldname[5]=Linux_Fedora35-x86_64-gcc11.2.1
newname[5]=Linux_Fedora35-x86_64-gcc11.2
oldname[6]=Linux_Ubuntu20.04-x86_64-gcc9.3.0
newname[6]=Linux_Ubuntu20.04-x86_64-gcc9.3

target=$1

if [ -z "$target" ]
then
    echo
    echo "error: no target supplied"
    echo
    print_usage
    exit 1
elif [[ "$target" != "jlab" && "$target" != "gluex_top" \
	    && "$target" != "halld_my" && "$target" != "jana" \
	    && "$target" != "hdds" && "$target" != "halld_recon" \
	    && "$target" != "halld_sim" && "$target" != "gluex_root_analysis" ]]
then
    echo
    echo "error: unknown target: $target"
    echo
    print_usage
    exit 2
fi
if [ "$target" == "gluex_top" ]
then
    if [ -z "$GLUEX_TOP" ]
    then
	echo
	echo error: GLUEX_TOP not set
	echo
	print_usage
	exit 3
    fi
fi
if [ "$target" == "halld_my" ]
then
    if [ -z "$HALLD_MY" ]
    then
	echo
	echo error: HALLD_MY not set
	echo
	print_usage
	exit 4
    fi
fi
if [ "$target" == "jana" ]
then
    if [ -z "$JANA_HOME" ]
    then
	echo
	echo error: JANA_HOME not set
	echo
	print_usage
	exit 4
    fi
fi
if [ "$target" == "hdds" ]
then
    if [ -z "$HDDS_HOME" ]
    then
	echo
	echo error: HDDS_HOME not set
	echo
	print_usage
	exit 4
    fi
fi
if [ "$target" == "halld_recon" ]
then
    if [ -z "$HALLD_RECON_HOME" ]
    then
	echo
	echo error: HALLD_RECON_HOME not set
	echo
	print_usage
	exit 4
    fi
fi
if [ "$target" == "halld_sim" ]
then
    if [ -z "$HALLD_SIM_HOME" ]
    then
	echo
	echo error: HALLD_SIM_HOME not set
	echo
	print_usage
	exit 4
    fi
fi
if [ "$target" == "gluex_root_analysis" ]
then
    if [ -z "$ROOT_ANALYSIS_HOME" ]
    then
	echo
	echo error: ROOT_ANALYSIS_HOME not set
	echo
	print_usage
	exit 4
    fi
fi
if [ "$target" == "jlab" ]
then
    pwd=`pwd`
    bn=`basename $pwd`
    if [ "$bn" != "builds" ]
    then
	echo
	echo error: not working in builds
	echo
	print_usage
	exit 5
    fi
fi

for i in {1..5}
do

    if [ "$target" == "jlab" ]
    then

	# if the new gluex_top does not exist
	if [ ! -d ${newname[$i]} ]
	then	
    
	    # create a gluex_top directory for the new name
	    if [ -d ${oldname[$i]} ]
	    then
		mkdir -v ${newname[$i]}
	    fi
	    
	    # make top-level package directories in the new gluex_top
	    find ${oldname[$i]} -maxdepth 1 -mindepth 1 -type d \
		| awk -v newname="${newname[$i]}" -F${oldname[$i]}/ \
		      '{ print "mkdir -v ./"newname"/"$2 }' | bash
    
	    # create soft links to the built package directories pointing from
	    # the new name directories to the old name directories
	    find ${oldname[$i]} -maxdepth 2 -mindepth 2 \
		| awk -v newname="${newname[$i]}" -F/ \
		      {'print "ln -sv ../../"$0" "newname"/"$2"/"$3'} | bash

	fi

    fi

    # create soft links parallel to BMS_OSNAMEd subdirectories under
    # the old-named package directories with new names pointing to the
    # old names in the same directory

    if [ "$target" == "gluex_top" ]
    then
	cd $GLUEX_TOP
	dir="."
	depth=3
    elif [ "$target" == "halld_my" ]
    then
	cd $HALLD_MY
	dir="."
	depth=1
    elif [ "$target" == "jana" ]
    then
	jana_root=`dirname $JANA_HOME`
	cd $jana_root
	dir="."
	depth=1
    elif [ "$target" == "hdds" ]
    then
	cd $HDDS_HOME
	dir="."
	depth=1
    elif [ "$target" == "halld_recon" ]
    then
	cd $HALLD_RECON_HOME
	dir="."
	depth=1
    elif [ "$target" == "halld_sim" ]
    then
	cd $HALLD_SIM_HOME
	dir="."
	depth=1
    elif [ "$target" == "gluex_root_analysis" ]
    then
	cd $ROOT_ANALYSIS_HOME
	dir="."
	depth=1
    elif [ "$target" == "jlab" ]
    then
	dir="${oldname[$i]}"
	depth=3
    else
	echo error: this cannot happen
	exit 6
    fi
    if [ $depth -eq 1 ]
    then
	find $dir -maxdepth $depth -mindepth $depth -name ${oldname[$i]} \
	| awk -F/ -v newname="${newname[$i]}" -v oldname="${oldname[$i]}" \
	      '{print "ln -sv "oldname" "newname}' | bash
    elif [ $depth -eq 3 ]
    then
	find $dir -maxdepth $depth -mindepth $depth -name ${oldname[$i]} \
	    | awk -F/ -v newname="${newname[$i]}" -v oldname="${oldname[$i]}" \
		  -v dirname="$dir" \
	'{print "ln -sv "oldname" "dirname"/"$2"/"$3"/"newname}' | bash
    else
	echo error: this cannot happen
	exit 7
    fi
done

# command to make a test directory
# find /group/halld/Software/builds -maxdepth 4 -type d | awk -F'/builds/' '{print "mkdir -pv builds/"$2}' | bash
