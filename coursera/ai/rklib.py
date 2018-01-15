import requests, json

def submit(submitterEmail,secret):
        with open('model.h5.base64', 'r') as myfile:
            data=myfile.read()
        submission = {
                    "assignmentKey": "XbAMqtjdEeepUgo7OOVwng",
                    "submitterEmail":  submitterEmail,
                    "secret":  secret,
                    "parts": {"LqPRQ" : {"output": data}}
                  }
        response = requests.post('https://www.coursera.org/api/onDemandProgrammingScriptSubmissions.v1', data=json.dumps(submission))
        if response.status_code == 201:
            print "Submission successful, please check on the coursera grader page for the status"
        else:
            print "Something went wrong, please have a look at the reponse of the grader"
            print "-------------------------"
            print response.text
            print "-------------------------"
