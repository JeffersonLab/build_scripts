#!/usr/bin/env python

import argparse
import subprocess
import sys
import xml.dom.minidom

packageList = ["hdds", "sim-recon", "halld_recon", "halld_sim", "hdgeant4", "gluex_root_analysis"]

# command line arguments

parser = argparse.ArgumentParser()
parser.add_argument("-x", "--xml", help="version set xml file name", default="version.xml")
parser.add_argument("inputPackages", help="list of packages to upgrade", nargs='*')
args = parser.parse_args()
inputfile = args.xml
inputPackages = args.inputPackages
print inputPackages

def updateCode(package, home):
    print "updating", package, "in", home
    p=subprocess.Popen(['git', 'pull'], cwd=home)
    p.wait()

def rebuild(package, home):
    print "rebuilding", package, "in", home
    aboveHome = home + "/.."
    cmd = "source $BUILD_SCRIPTS/gluex_env_jlab.sh " + inputfile + "; make -f $BUILD_SCRIPTS/Makefile_" + package
    p=subprocess.Popen(cmd, cwd=aboveHome, shell=True)
    p.wait()

# input values
DOMTree = xml.dom.minidom.parse(inputfile)
gversion = DOMTree.documentElement
packages=gversion.getElementsByTagName("package")
homeDir = {}
for package in packages:
    name = str(package.getAttribute("name"))
    home = str(package.getAttribute("home"))
    print str(package), name, home
    if name in inputPackages:
        if home:
            homeDir[name] = home
            print homeDir[name]
        else:
            message = "error: requested package " + name + " does not have the home attribute defined in " + inputfile
            sys.exit(message)
print homeDir
for package in packageList:
    print package
    if package in homeDir:
        home = homeDir[package]
        updateCode(package, home)
        rebuild(package, home)
