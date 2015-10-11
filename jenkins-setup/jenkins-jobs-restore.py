#curl -X POST -H "Content-Type:application/xml" -d @config.xml "http://10.193.83.39:8080/createItem?name=TEST_JOB4"

import glob
import os
import urllib2

f = open('jenkins-server-ip.txt', 'r')
jenkins_ip = f.read().rstrip()
print jenkins_ip

jobs = glob.glob("jenkins-jobs/*.xml")
for job in jobs:
	file_parts = os.path.splitext( os.path.basename(job))
	name = file_parts[0]
	url = 'http://' + jenkins_ip + ':8080/createItem?name=' + name
	
	with open (job, "r") as myfile:
		xml_data = myfile.read()

	headers = {'Content-type': 'application/xml'}
	
	req = urllib2.Request(url=url, data=xml_data, headers=headers)
	urllib2.urlopen(req)