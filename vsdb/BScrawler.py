#!/usr/bin/env python
import pymysql
pymysql.install_as_MySQLdb()
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

def checkOasisCVMFS(packagename,version,dirtag):
    rootdir="/group/halld/Software/builds/Linux_CentOS7-x86_64-gcc4.8.5-cntr/"
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
    locat=rootdir+packagename.replace("\"","")+"/"+folder_name+"/"

   
    if os.path.isdir(locat) or packagename.replace("\"","")=="root":
        #print("!!!!!!!!!!!!!!!!!!!!!!!!!YAY!!!!!!!!!!!!!!!!!!!!!!!!!!")
        return 1
    else:
        if(packagename.replace("\"","") == "cernlib" and version.replace("\"","")=="2005"):
            print(locat)
            print("~~~~~~~~~~~~~~~~~~~~~~~~~BOO~~~~~~~~~~~~~~~~~~~~~~~~~~")
        return 0

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
                    #print update_description
                    curs.execute(update_description)
                    conn.commit()

                    continue
                #print "~~~~~~~~~~~~~~~~~~~~~~~"
                #print child.attrib
                #if 'name' not in child.attrib:
                #    continue
                check_package_num="SELECT id from package where name=\""+child.attrib['name']+"\";"
                print(check_package_num)
                curs.execute(check_package_num)
                num = curs.fetchall()

                ID=-1
                print("Getting ID number")
                print(num)
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


                verOnOasis=checkOasisCVMFS(child.attrib['name'],version,dirtag)
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
            onOasisCheck_q="SELECT * from version where onOasis=0 and versionSetId in (SELECT id from versionSet where filename=\""+str(afile)+"\");"
            curs.execute(onOasisCheck_q)
            results= curs.fetchall()
            #print(results)
            setOnOasis=0
            if(len(results)==0 or afile == "version_cntr_Mon.xml"  or afile == "version_cntr_Thu.xml" or afile == "version_cntr_Wed.xml" or afile == "version_cntr_Fri.xml"):
                setOnOasis=1
                update_onOasis="UPDATE versionSet SET onOasis=1 WHERE filename=\""+str(afile)+"\""
                print(update_onOasis)
                curs.execute(update_onOasis)
                conn.commit()
                print("OASIS!!!!!!!")

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
