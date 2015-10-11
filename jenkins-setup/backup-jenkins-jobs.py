import json
from pprint import pprint

f = open('jenkins-server-ip.txt', 'r')
jenkins_ip = f.read().rstrip()
print jenkins_ip

jenkins_url = 'http://' + jenkins_ip + ':8080/api/json'
print jenkins_url

data = json.load(urllib2.urlopen(jenkins_url))

for item in data['jobs']:
	job_name = item['name']
	job_url = item['url']
	config_url = job_url + 'config.xml'
	print 'downloading "' + job_name + '" job from: ' + config_url
	
	s = urllib2.urlopen(config_url)
	contents = s.read()
	file = open('jenkins-jobs/' + job_name + '.xml', 'w')
	file.write(contents)
	file.close()

