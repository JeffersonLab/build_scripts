#!/apps/python/3.3.1/bin/python3

# note that this is in python 3, since the version of python 2.7 on the CUE is not
# new enough to properly support the libraries that handle our SSL connection to GitHub
# python 3 has many tricky difference between python2 - be warned!

import requests
import sys

if len(sys.argv) < 4:
    print("Not enough arguments!")
    exit

user = None
password = None

# github credentials are stored in separate file
login_file = sys.argv[1]
with open(login_file) as f:
    lines = f.readlines()
    user = lines[0].strip()
    password = lines[1].strip()

if user is None or password is None:
    print("invalid credentials")
    exit

comment_url = sys.argv[2]
comment = sys.argv[3]

# leave comment
message = "{ \"body\" : \""+comment+"\" }"
print (message)
#r = requests.post(comment_url, data=message, auth=(user,password), verify='/site/etc/openssl/JLabCA.crt')
r = requests.post(comment_url, data=message, auth=(user,password))
# response stored as "r.text"
print("Result of comment POST:")
print(r.text)
