import sys
sys.stdout = sys.stderr

import json
import re
import subprocess
import os

import atexit
import threading
import cherrypy

cherrypy.config.update({'environment': 'embedded'})

if cherrypy.__version__.startswith('3.0') and cherrypy.engine.state == 0:
    cherrypy.engine.start(blocking=False)
    atexit.register(cherrypy.engine.stop)

## web application
class Root(object):
    exposed = True
    #def GET(self):
    #    return "hi"

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

    def POST(self, *args):
        outstr = str(cherrypy.request.headers)

        # parse the data
        data = json.loads(cherrypy.request.body.read())
        
        # only do anything if the pull requests is opened or reopened 
        if data["action"] == "opened" or data["action"] == "reopened" or data["action"] == "synchronize":
            # do some sanity checks
            pull_request_url = data["pull_request"]["issue_url"]
            pull_request_comment_url = data["pull_request"]["comments_url"]  # we need this info to report the status back on the pull request
            pull_request_branch = data["pull_request"]["head"]["ref"]
            if not self.validate_input(pull_request_branch):
                return "bad branch name: %s"%pull_request_branch
            # process git branch name
            branch_name = data["pull_request"]["head"]["ref"]
            # sanitize data - escape single and double quotes 
            # this is a little paranoid, but better safe...
            branch_name_cleaned = branch_name.replace('"', '\\"')
            branch_name_cleaned.replace("'", "\\'")
            # get the URL of the git repo, to support forked repos
            # probably should clean this URL too..
            repo_url = data["pull_request"]["base"]["repo"]["html_url"]

            # launch the test build
            # we use a single-command ssh key to launch the build on the ifarm
            cmd = "env -u SSH_AUTH_SOCK ssh -i /home/marki/.ssh/id_dsa_pull_request gluex@sandd1 %s %s %s"%(branch_name_cleaned,pull_request_comment_url,repo_url)
            subprocess.Popen(cmd, shell=True)
            return "Test build for branch %s from repository %s launched successfully!"%(branch_name_cleaned,repo_url) 
        else:
            return "Ignoring this callback."

        #return str("DATA:\n\n" + str(cherrypy.request.body.read()))

## cherrpy configuration
conf = {
    '/': {
        'request.dispatch': cherrypy.dispatch.MethodDispatcher(),
        'tools.sessions.on': True,
        'tools.response_headers.on': True,
        'tools.response_headers.headers': [('Content-Type', 'text/plain')],
        }
    }

application = cherrypy.Application(Root(), script_name=None, config=conf)
