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

conn=MySQLdb.connect(host=dbhost, user=dbuser, db=dbname)
curs=conn.cursor(MySQLdb.cursors.DictCursor)


def main(argv):
    deleteversets="DELETE FROM versionSet;"
    curs.execute(deleteversets)
    conn.commit()
    deletevers="DELETE FROM version;"
    curs.execute(deletevers)
    conn.commit()

    

    loc="/group/halld/www/halldweb/html/dist/"
    directories=os.listdir(loc)
    for dire in directories:
        if "_jlab" not in dire:
            continue
        if "~" in dire:
            continue
        if dire == "version_jlab.xml":
            continue
        # ADD dire to versionset.  Get that version set id
        check_for_file="SELECT id from versionSet where filename=\""+dire+"\";"
        print check_for_file
        curs.execute(check_for_file)
        row = curs.fetchall()

        if len(row) > 0:
            print "SKIP"
            continue

        #check for 
        onOasis=1

        insert_versionset="INSERT INTO versionSet (directoryId, filename, fileExists, onOasis) VALUES (1, \""+dire.replace(" ","_")+"\", 1,"+str(onOasis) +");"
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



        tree = ET.parse(loc+dire)
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