#!/usr/bin/python

# CGI script to process GitHub webhook callback and launch a test build 
# based on the branch referenced in a pull request
# Basic auth over HTTPS is used

import web
import json
#import requests
import re
import subprocess
import os

#import smtplib
#from email.mime.text import MIMEText

class hooks:
    def __init__(self):
        self.webhook_user = "test"
        self.webhook_password = "testest"
        self.github_user = "<None>"
        self.github_password = "<None>"
        #with open(".config") as f:
        #    lines = f.readlines()
        #    # TODO: add more error checking
        #    self.github_user = lines[0].strip()
        #    self.github_password = lines[1].strip()
            
    def validate_input(self, str):
        # we do these checks to attempt to reject malformed or
        # malicious inputs - 
        # we reject inputs containing ';', '['
        # we escape single and double quotes later on
        if ';' in str:
            return False
        if '[' in str:
            return False
        return True

    def check_auth(username, password):
        return username == self.webhook_user and password == self.webhook_password

    def GET(self):
        print 
        print "hello"
        return "OK"

    def POST(self):
        print
        #print "HI THERE"
        #print str(web.ctx.env)
        #return "ok"
        ## do some simple HTTPS basic auth
        #auth = web.ctx.env.get('HTTP_AUTHORIZATION')
        #if auth is not None:
        #    print str(auth)
        #print
        #i = web.input()
        #print str(i)
        #print
        #if auth:
        #    auth = re.sub('^Basic ', '', auth)
        #    username, password = base64.decodestring(auth).split(':')
        #    print "username = %s   password = %s"%(username, password)
        #if not auth or not self.check_auth(username, password):
        #    web.header('WWW-Authenticate','Basic realm="sim-recon build"')
        #    web.ctx.status = '401 Unauthorized'
        #    return

        # parse the data
        data = json.loads(web.data())
        #print
        #print "DATA RECEIVED:"
        #print data
        # only do anything if the pull requests is opened or reopened 
        if data["action"] == "opened" or data["action"] == "reopened":
            # do some sanity checks
            pull_request_url = data["pull_request"]["issue_url"]
            pull_request_comment_url = data["pull_request"]["comments_url"]  # we need this info to report the status back on the pull request
            pull_request_branch = data["pull_request"]["head"]["ref"]
            if not self.validate_input(pull_request_branch):
                print "bad branch name: %s"%pull_request_branch
                return self.internalerror()
            # process git branch name
            branch_name = data["pull_request"]["head"]["ref"]
            # sanitize data - escape single and double quotes 
            # this is a little paranoid, but better safe...
            branch_name_cleaned = branch_name.replace('"', '\\"')
            branch_name_cleaned.replace("'", "\\'")

            # launch the test build
            # we use a single-command ssh key to launch the build on the ifarm
            cmd = "env -u SSH_AUTH_SOCK ssh -i /home/marki/.ssh/id_dsa_pull_request gluex@ifarm1102 %s %s"%(branch_name_cleaned,pull_request_comment_url)
            #os.environ['USER'] = "apache"  # hack for cgi environment
            subprocess.Popen(cmd, shell=True)
            print "Test build for branch %s launched successfully!"%branch_name_cleaned 
        #
        return 'OK'

if __name__ == "__main__":
    urls = ('/.*', 'hooks')
    web.application(urls, globals()).run()
