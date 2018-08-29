#!/usr/bin/env python

import argparse
import os
import subprocess
import sys
import xml.dom.minidom

print "type", "\"" + os.path.basename(__file__), "-h\" for usage message"

packageList = ["hdds", "sim-recon", "halld_recon", "halld_sim", "hdgeant4", "gluex_root_analysis"]

# command line arguments

parser = argparse.ArgumentParser()
parser.add_argument("-x", "--xml", help="version set xml file name (default: version.xml)", default="version.xml")
parser.add_argument("-n", "--nthreads", help="number of threads to use in rebuild (default: 1)", default=1)
parser.add_argument("inputPackages", help="list of packages to update", nargs='*')
args = parser.parse_args()
inputfile = args.xml
if not os.path.isfile(inputfile):
    message = "error: version set file \"" + inputfile + "\" does not exist"
    sys.exit(message)
nthreads = args.nthreads
nthreadsStr = str(nthreads)
buildOptions = {}
buildOptions["hdds"] = "FORCE=1"
buildOptions["sim-recon"] = "FORCE=1"
buildOptions["halld_recon"] = "FORCE=1"
buildOptions["halld_sim"] = "FORCE=1"
buildOptions["hdgeant4"] = "FORCE=1"
buildOptions["gluex_root_analysis"] = "FORCE=1"
if nthreads > 1:
    buildOptions["sim-recon"] += " SIM_RECON_SCONS_OPTIONS=-j" + nthreadsStr
    buildOptions["halld_recon"] += " HALLD_RECON_SCONS_OPTIONS=-j" + nthreadsStr
    buildOptions["halld_sim"] += " HALLD_SIM_SCONS_OPTIONS=-j" + nthreadsStr
inputPackages = args.inputPackages
if len(inputPackages) == 0:
    inputPackages = packageList
    defaultToAllPackages = True
#print "packages to update:", inputPackages

# get a value for BUILD_SCRIPTS

build_scripts = ""
if "BUILD_SCRIPTS" in os.environ:
    build_scripts = os.environ["BUILD_SCRIPTS"]
    if not os.path.isdir(build_scripts):
        message = "error: BUILD_SCRIPTS directory from environment, " + build_scripts + ", does not exist"
        sys.exit(message)
else:
    groupDir = "/group/halld/Software/build_scripts"
    if os.path.isdir(groupDir):
        build_scripts = groupDir

if build_scripts:
    print "info: using build_scripts from", build_scripts
else:
    message = "error: BUILD_SCRIPTS directory not found, please set it"
    sys.exit(message)

def updateCode(package, home):
    print "info: updating", package, "in", home, "with git pull"
    p=subprocess.Popen(['git', 'pull'], cwd=home)
    p.wait()

def rebuild(package, home):
    print "info: rebuilding", package, "in", home, "with $BUILD_SCRIPTS/Makefile_" + package
    aboveHome = home + "/.."
    cmd = "export BUILD_SCRIPTS=" + build_scripts + "; source $BUILD_SCRIPTS/gluex_env_clean.sh; export BUILD_SCRIPTS=" + build_scripts + "; source $BUILD_SCRIPTS/gluex_env_jlab.sh " + inputfile + "; make -f $BUILD_SCRIPTS/Makefile_" + package + " " + buildOptions[package]
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
    #print str(package), name, home
    if name in inputPackages:
        if home:
            homeDir[name] = home
            #print homeDir[name]
        else:
            if not defaultToAllPackages:
                message = "error: requested package " + name + " does not have the home attribute defined in " + inputfile
                sys.exit(message)
#print homeDir
for package in packageList:
    #print package
    if package in homeDir:
        home = homeDir[package]
        updateCode(package, home)
        rebuild(package, home)
