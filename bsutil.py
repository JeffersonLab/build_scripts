#!/usr/bin/env python

import argparse
import os
import subprocess
import sys
import xml.dom.minidom

print "type", "\"" + os.path.basename(__file__), "-h\" for usage message"

packageList = ["hdds", "sim-recon", "halld_recon", "halld_sim", "hdgeant4", "gluex_root_analysis"]

def new(args):
    print("doing a new build")
def update(args):
    print("updating an old build")
