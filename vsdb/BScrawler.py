#!/usr/bin/env python
#import pymysql
#pymysql.install_as_MySQLdb()
import MySQLdb
import sys
import datetime
import os.path
from optparse import OptionParser
import subprocess
from subprocess import call
from subprocess import Popen, PIPE
import socket
import pprint
import xml.etree.ElementTree as ET

dbhost = "hallddb.jlab.org"
dbuser = 'vsuser'
dbpass = ''
dbname = 'vsdb'
try:
    conn=MySQLdb.connect(host=dbhost, user=dbuser, db=dbname)
    curs=conn.cursor(MySQLdb.cursors.DictCursor)
except:
    print("CAN'T CONNECT")

def checkOasisCVMFS(packagename,version,dirtag,osversions):
    """
    Loop over all 'OSVersions' and check if the provided package is available.
    Return an integer where the bit corresponding to the OSVersion's 'ID' is
    set to 1 if the software is available on that version.
    """
    rootdir = "/group/halld/Software/builds/"
    
    folder_name=packagename.replace("\"","")
        #because of course it isn't the same!
        #%dir_prefix = (root => 'root[_-]',
	    #   clhep => '',
	    #   jana => 'jana_',
	    #   'sim-recon' => 'sim-recon-',
	    #   hdds => 'hdds-',
	    #   cernlib => 'special case',
	    #   'xerces-c' => 'xerces-c-',
	    #   geant4 => 'geant4.',
	    #   ccdb => 'ccdb_',
	    #   evio => 'evio-',
	    #   rcdb => 'rcdb_',
        #       hdgeant4 => 'hdgeant4-',
        #       hd_utilities => 'hd_utilities-',
        #       gluex_root_analysis => 'gluex_root_analysis-',
        #       amptools => 'AmpTools-',
        #       sqlitecpp => 'SQLiteCpp-',
        #       sqlite => 'sqlite-',
        #       gluex_MCwrapper => 'gluex_MCwrapper-',
        #       halld_sim => 'halld_sim-',
        #       halld_recon => 'halld_recon-',
	    #   lapack => 'lapack-',
	    #   hepmc => 'HepMC-',
	    #   photos => 'Photos-',
	    #   evtgen => 'evtgen-'
    if packagename.replace("\"","") == "clhep":
        folder_name=folder_name+""
    elif packagename.replace("\"","") == "cernlib":
        folder_name=""
    elif packagename.replace("\"","") == "jana" or packagename.replace("\"","") == "ccdb" or packagename.replace("\"","") == "rcdb":
        folder_name=folder_name+"_"
    elif packagename.replace("\"","") == "geant4":
        folder_name=folder_name+"."
    elif packagename.replace("\"","") == "amptools":
        folder_name="AmpTools-"
    elif packagename.replace("\"","") == "sqlitecpp":
        folder_name="SQLiteCpp-"
    elif packagename.replace("\"","") == "photos":
        folder_name="Photos-"
    elif packagename.replace("\"","") == "evtgen":
        folder_name="evtgen-"
    elif packagename.replace("\"","") == "hepmc":
        folder_name="HepMC-"
    elif packagename.replace("\"","") == "diracxx":
        folder_name="Diracxx-"
    else:
        folder_name=folder_name+"-"

    folder_name=folder_name+version.replace("\"","")

    if(folder_name=="halld_sim-4.6.0" or folder_name=="halld_sim-4.7.0"): #BLACKLIST FOR CCDB ISSUES
        return 0

    if(dirtag.replace("\"","") != "NULL"):
        folder_name=folder_name+"^"+dirtag.replace("\"","")
    
    bitmask = 0
    for osver in osversions:
        locOSName = osver['OSName']
        if locOSName == "Linux_Alma9-x86_64-gcc11.4.1-cntr":
            locOSName = "Linux_Alma9-x86_64-gcc11.5.0-cntr"
        
        locat = rootdir + locOSName + "/" + packagename.replace("\"","") + "/" + folder_name + "/"
        if os.path.isdir(locat) or packagename.replace("\"","")=="root":
            #print("!!!!!!!!!!!!!!!!!!!!!!!!!YAY!!!!!!!!!!!!!!!!!!!!!!!!!!")
            bitmask |= osver['ID']
    
    return bitmask

def main(argv):
#main loc="/group/halld/www/halldweb/html/dist/"
    
    pushcmd="mysql --host="+dbhost+" --database="+dbname+" --user="+dbuser#+"<tables.sql"

    p = subprocess.Popen(pushcmd.split(" "),stdin=subprocess.PIPE)
    with open("/group/halld/Software/build_scripts/vsdb/tables.sql", "r") as f:
        stdout, stderr = p.communicate(f.read().encode())
    #stdout,stderr = p.communicate(file("/group/halld/Software/build_scripts/vsdb/tables.sql").read())
    
    
    reconpackcmd="xsltproc /group/halld/Software/build_scripts/xml/packages_sql.xslt /group/halld/Software/build_scripts/xml/packages.xml | grep INSERT | "+"mysql -h "+dbhost+" -D "+dbname+" -u "+dbuser
    #print reconpackcmd
    
    ps = subprocess.Popen(reconpackcmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    output = ps.communicate()[0]
    
    # Get list of available OSVersions to check for software availability:
    curs.execute("select * from OSVersions order by ID desc")
    osversions = curs.fetchall()
    if(len(osversions)<0):
        print("No OSVersions found")
        sys.exit(1)
    
    for loc in argv:
        locid=-1
        #print loc
        check_for_loc="select id from directory where dirname=\""+loc+"\";"
        curs.execute(check_for_loc)
        locentry = curs.fetchall()
        if(len(locentry)>0):
            locid=locentry[0]["id"]
        else:
            insertlocq="insert into directory (dirname) values (\""+loc+"\")"
            curs.execute(insertlocq)
            conn.commit()
            curs.execute(check_for_loc)
            newdir = curs.fetchall()
            locid=newdir[0]["id"]


        directories=os.listdir(loc)
        for afile in directories:
            
            if ".xml" not in afile:
                continue
            if "~" in afile:
                continue
            if afile == "version_jlab.xml" or afile == "version_set_correlations.xml" or afile=="version.xml":
                continue
            #if "test" in afile:
            #    continue
            # ADD afile to versionset.  Get that version set id
            check_for_file="SELECT id from versionSet where filename=\""+afile+"\";"
            #print check_for_file
            curs.execute(check_for_file)
            row = curs.fetchall()

            if len(row) > 0:
                print("SKIP")
                continue


            #check for
            
            #onOasis=checkOasis(loc,afile)
            insert_versionset="INSERT INTO versionSet (directoryId, filename, fileExists) VALUES ("+str(locid)+", \""+afile.replace(" ","_")+"\", 1 );"
            #insert_versionset="INSERT INTO versionSet (directoryId, filename, fileExists) VALUES ("+str(locid)+", \""+afile.replace(" ","_")+"\", 1"+");"
            print(insert_versionset)
            curs.execute(insert_versionset)
            conn.commit()

            curs.execute(check_for_file)
            row = curs.fetchall()
            versionsetID=0
            
            if len(row) > 0:
                versionsetID=row[0]['id']
                #print row[0]['id']
            #print "---------------------------"


            tree = ET.parse(loc+afile)
            root = tree.getroot()


            #print root.attrib['description']
            for child in root:

                if child.tag == "description":
                    #print child
                    text=child.text
                    text=text.replace("\"","\\\"")
                    print(text)
                    update_description="UPDATE versionSet SET description=\""+text+"\""+" WHERE id="+str(versionsetID)
                    #print(update_description)
                    curs.execute(update_description)
                    conn.commit()
                    continue
                #print "~~~~~~~~~~~~~~~~~~~~~~~"
                #print child.attrib
                #if 'name' not in child.attrib:
                #    continue
                check_package_num="SELECT id from package where name=\""+child.attrib['name']+"\";"
                #print(check_package_num)
                curs.execute(check_package_num)
                num = curs.fetchall()

                ID=-1
                #print("Getting ID number")
                #print(num)
                #if len(num[0])
                if num[0]['id']:
                    ID=num[0]['id']
                #print ID

                dirtag="NULL"
                if 'dirtag' in child.attrib:
                    dirtag="\""+child.attrib['dirtag']+"\""

                version="NULL"
                if 'version' in child.attrib:
                    version="\""+child.attrib['version']+"\""

                branch="NULL"
                if 'branch' in child.attrib:
                    branch="\""+child.attrib['branch']+"\""

                hashname="NULL"
                if 'hash' in child.attrib:
                    hashname="\""+child.attrib['hash']+"\""

                year="NULL"
                if 'year' in child.attrib:
                    year="\""+child.attrib['year']+"\""

                home="NULL"
                if 'home' in child.attrib:
                    home="\""+child.attrib['home']+"\""

                word_length="NULL"
                if 'word_length' in child.attrib:
                    word_length="\""+child.attrib['word_length']+"\""

                debug_level="NULL"
                if 'debug_level' in child.attrib:
                    debug_level="\""+child.attrib['debug_level']+"\""


                verOnOasis=checkOasisCVMFS(child.attrib['name'],version,dirtag,osversions)
                insert_version="INSERT INTO version (versionSetId, packageId, version,dirtag, branch, hash, year, home, word_length, debug_level,onOasis) VALUES ("+str(versionsetID)+","+str(num[0]['id'])+","+version+","+dirtag+","+branch+","+hashname+","+year+","+home+","+word_length+","+debug_level+","+str(verOnOasis)+");"
                #print insert_version
                curs.execute(insert_version)
                conn.commit()

            #print "============================="
        print("+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+_+")
        for afile in directories:
            #if "_jlab" not in afile:
            #    continue
            if ".xml" not in afile:
                continue
            if "~" in afile:
                continue
            if afile == "version_jlab.xml" or afile == "version_set_correlations.xml":
                continue
            
            print(afile)
            
            """
            Now we want to check if we should update the 'onOasis' column of the versionSet table.
            
            To do so, we will go through all available OSVersions (ordered in descending order by their 'ID').
            We check to see if there are any entries into the 'versions' table with this versionSetId
            whose 'onOasis' value doesn't have the bit corresponding to this OSVersion's 'ID' set to 1. 
            
            If there are no such entries, it means all included packages withiin this versionSet exist within that 
            OSVersions' build directory. If that is the case, we set the 'onOasis' value for this row of the 'versionSet' table to 1,
            and we update the 'OS_ID' value, setting it equal to the 'ID' of the corresponding OSVersion. 
            Then, we break the loop over all OSVersions. This means if all software packages of a given version set are available on 
            multiple OS's, the 'OS_ID' value for that version set will always get set to the OSVersion with the largest 'ID' 
            (presumably, it will always be the most recent one).
            
            This feature of using the most recent OSVersion available for a given versionSet should not be applied for version sets
            whose names start with "analysis-" or "recon-". For those, we hard code some exceptions.
            """
            
            if afile.startswith("analysis-") or afile.startswith("recon-") or afile.startswith("version_recon"):
                # The exceptions to the above algorithm.
                
                # Start by assuming a version set corresponds to Alma9. Update as necessary:
                locOSID = 2
                
                #-----------------------------------------#
                
                if afile.startswith("analysis-"):
                    # The following assumes these files are named like: 'analysis-<run_period>-ver<ver_no>.xml'. Is it a safe assumption?
                    run_period = afile.split('-')[1]
                    ver_no     = int(afile.split('-')[2].split('.')[0][3:])
                    
                    # The following variable represents the highest numbered version where CentOS7 was used.
                    # Hard-code some cutoffs for each run period:
                    max_ver_centos7 = 0
                    if run_period == "2017_01":
                        max_ver_centos7 = 70
                    elif run_period == "2018_01":
                        max_ver_centos7 = 24
                    elif run_period == "2018_08":
                        max_ver_centos7 = 23
                    elif run_period == "2019_11":
                        max_ver_centos7 = 10
                    
                    if ver_no <= max_ver_centos7:
                        locOSID = 1
                
                elif afile.startswith("recon-"):
                    
                    # The following assumes these files are named like: 'recon-<run_period>-ver<ver_no>.xml'. Is it a safe assumption?
                    run_period = afile.split('-')[1]
                    ver_str    = afile.split('-')[2][3:].split('.')[0]
                    ver_major  = int(ver_str.split('_')[0])
                    
                    # The following variable represents the highest 'major' version where CentOS7 was used.
                    # I am assuming if new recon launches are made of past data sets, they will have a new 'major' version.
                    
                    max_ver_centos7 = 0
                    if run_period == "2017_01":
                        max_ver_centos7 = 4
                    elif run_period == "2018_01":
                        max_ver_centos7 = 2
                    elif run_period == "2018_08":
                        max_ver_centos7 = 2
                    elif run_period == "2019_11":
                        max_ver_centos7 = 1
                    elif run_period == "2021_11":
                        max_ver_centos7 = 1
                    
                    if ver_no <= max_ver_centos7:
                        locOSID = 1
                
                onOasisCheck_q = "SELECT * from version where (onOasis & "+str(locOSID)+")=0 and versionSetId in (SELECT id from versionSet where filename=\""+str(afile)+"\");"
                curs.execute(onOasisCheck_q)
                results = curs.fetchall()
                if(len(results)==0):
                    update_onOasis="UPDATE versionSet SET onOasis=1, OS_ID="+str(locOSID)+" WHERE filename=\""+str(afile)+"\""
                    print(update_onOasis)
                    curs.execute(update_onOasis)
                    conn.commit()
            elif afile=="version_cntr_Mon.xml" or afile=="version_cntr_Fri.xml":
                # 'recent' builds available on Alma9 container
                update_onOasis="UPDATE versionSet SET onOasis=1, OS_ID=2 WHERE filename=\""+str(afile)+"\""
                print(update_onOasis)
                curs.execute(update_onOasis)
                conn.commit()
            else:
                for osver in osversions:
                    onOasisCheck_q = "SELECT * from version where (onOasis & "+str(osver['ID'])+")=0 and versionSetId in (SELECT id from versionSet where filename=\""+str(afile)+"\");"
                    curs.execute(onOasisCheck_q)
                    results = curs.fetchall()
                    if(len(results)==0):
                        update_onOasis="UPDATE versionSet SET onOasis=1, OS_ID="+str(osver['ID'])+" WHERE filename=\""+str(afile)+"\""
                        print(update_onOasis)
                        curs.execute(update_onOasis)
                        conn.commit()
                        break
        
        print("BUILDING CORRELATION TABLE")
        path=loc+"version_set_correlations.xml"
        print(path)
        if ( os.path.isfile(path) ):
            print("=============================")
            cortree = ET.parse(loc+"version_set_correlations.xml")
            corroot = cortree.getroot()
            for child in corroot:
                print(child.attrib)
                date="NULL"
                if 'date' in child.attrib:
                    date=child.attrib['date']
                
                recon_launch=-1
                analysis_launch=-1
                
                
                recon_stub_name=""
                ana_launch_name=""
                for verset in child:
                    if ( verset.tag == "recon_launch" and "version_set" in verset.attrib ):
                        recon_stub_name=str(verset.attrib["version_set"])
                #    #    id_sel="select id from versionSet where filename=\""+str(verset.attrib["version_set"])+"\" && directoryID="+str(locid)
                #    #    print(id_sel)
                #    #    curs.execute(id_sel)
                #    #    results= curs.fetchall()
                #    #    if (len(results) == 1 ):
                #    #        recon_launch=results[0]['id']
#
                    if ( verset.tag == "analysis_launch" and "version_set" in verset.attrib ):
                        ana_launch_name=str(verset.attrib["version_set"])
                #        id_sel="select id from versionSet where filename=\""+str(verset.attrib["version_set"])+"\" && directoryID="+str(locid)
                #        print(id_sel)
                #        curs.execute(id_sel)
                #        results= curs.fetchall()
                #        if (len(results) == 1 ):
                #            analysis_launch=results[0]['id']
                print(recon_stub_name)
                print(ana_launch_name)
                id_sel="select id from versionSet where filename=\""+str(ana_launch_name)+"\" && directoryID="+str(locid)
                print(id_sel)
                curs.execute(id_sel)
                results= curs.fetchall()
                if (len(results) == 1 ):
                    analysis_launch=results[0]['id']

                for files in os.listdir(loc):
                    if recon_stub_name in files:
                        print(files)
                        id_sel="select id from versionSet where filename=\""+str(files)+"\" && directoryID="+str(locid)
                        print(id_sel)
                        curs.execute(id_sel)
                        results= curs.fetchall()
                        if (len(results) == 1 ):
                            recon_launch=results[0]['id']
                
                        print(recon_launch)
                        print(analysis_launch)
                        insert_set_correlation="INSERT INTO version_set_correlations (directoryId, date, reconSetID, analysisSetId) VALUES ("+str(locid)+", \""+str(date)+"\", "+str(recon_launch)+", "+str(analysis_launch)+" );"
                        print(insert_set_correlation)
                        curs.execute(insert_set_correlation)
                        conn.commit()
        
        conn.close()


if __name__ == "__main__":
   main(sys.argv[1:])
