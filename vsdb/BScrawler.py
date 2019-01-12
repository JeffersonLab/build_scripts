#!/usr/bin/env python
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
    print "CAN'T CONNECT"


def main(argv):
#main loc="/group/halld/www/halldweb/html/dist/"

    pushcmd="mysql --host="+dbhost+" --database="+dbname+" --user="+dbuser#+"<tables.sql"

    p = subprocess.Popen(pushcmd.split(" "),stdin=subprocess.PIPE)
    stdout,stderr = p.communicate(file("./tables.sql").read())
   
    
    reconpackcmd="xsltproc ../xml/packages_sql.xslt ../xml/packages.xml | grep INSERT | "+"mysql -h "+dbhost+" -D "+dbname+" -u "+dbuser
    print reconpackcmd
    
    ps = subprocess.Popen(reconpackcmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    output = ps.communicate()[0]
    

    for loc in argv:
        locid=-1
        print loc
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
            if "_jlab" not in afile:
                continue
            if "~" in afile:
                continue
            if afile == "version_jlab.xml":
                continue
            # ADD afile to versionset.  Get that version set id
            check_for_file="SELECT id from versionSet where filename=\""+afile+"\";"
            print check_for_file
            curs.execute(check_for_file)
            row = curs.fetchall()

            if len(row) > 0:
                print "SKIP"
                continue


            #check for 
            onOasis=1
            insert_versionset="INSERT INTO versionSet (directoryId, filename, fileExists, onOasis) VALUES ("+str(locid)+", \""+afile.replace(" ","_")+"\", 1,"+str(onOasis) +");"
            #insert_versionset="INSERT INTO versionSet (directoryId, filename, fileExists) VALUES ("+str(locid)+", \""+afile.replace(" ","_")+"\", 1"+");"
            print insert_versionset
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
                    update_description="UPDATE versionSet SET description=\""+text+"\""+" WHERE id="+str(versionsetID)
                    print update_description
                    curs.execute(update_description)
                    conn.commit()

                    continue
                #print "~~~~~~~~~~~~~~~~~~~~~~~"
                #print child.attrib
                #if 'name' not in child.attrib:
                #    continue
                check_package_num="SELECT id from package where name=\""+child.attrib['name']+"\";"
                #print check_package_num
                curs.execute(check_package_num)
                num = curs.fetchall()

                ID=-1
                #print num
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

                insert_version="INSERT INTO version (versionSetId, packageId, version,dirtag, branch, hash, year, home, word_length, debug_level) VALUES ("+str(versionsetID)+","+str(num[0]['id'])+","+version+","+dirtag+","+branch+","+hashname+","+year+","+home+","+word_length+","+debug_level+");"
                print insert_version
                curs.execute(insert_version)
                conn.commit()

            print "============================="

        conn.close()


if __name__ == "__main__":
   main(sys.argv[1:])