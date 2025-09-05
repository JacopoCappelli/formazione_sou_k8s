export ADMIN = admin 
export PASSWD=$(docker exec jenkins-master cat /var/jenkins_home/secrets/initialAdminPassword)
export TOKEN=my-token
export CRUMB=$(curl -s -c cookies.txt -u $ADMIN:$PASSWD http://localhost:8080/crumbIssuer/api/json | jq -r '.crumb')


curl -c cookies.txt -u $ADMIN:$PASSWD http://localhost:8080/crumbIssuer/api/json
curl -v -u "$ADMIN:$PASSWD" -b cookies.txt -H "Jenkins-Crumb: $CRUMB" -X POST http://localhost:8080/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken/newTokenName=$TOKEN

curl -X POST "http://localhost:8080/computer/doCreateItem?name=my_agent_name&type=hudson.slaves.DumbSlave" \
-u "$ADMIN:$PASSWD" \
-H "Content-Type: application/x-www-form-urlencoded" \
-H "Jenkins-Crumb: $CRUMB" \
-b cookies.txt \
--data-urlencode "json={
\"name\": \"my_agent_name\",
\"nodeDescription\": \"\",
\"numExecutors\": \"1\",
\"remoteFS\": \"/home/jenkins/agent\",
\"labelString\": \"\",
\"mode\": \"EXCLUSIVE\",
\"type\": \"hudson.slaves.DumbSlave\$DescriptorImpl\",
\"retentionStrategy\": {
\"stapler-class\": \"hudson.slaves.RetentionStrategy\$Always\"
},
\"nodeProperties\": {
\"stapler-class-bag\": \"true\"
},
\"launcher\": {
\"stapler-class\": \"hudson.slaves.JNLPLauncher\"
}
}"

export SECRET=$(

        curl -s -u "$ADMIN:$PASSWD" -b cookies.txt "http://localhost:8080/computer/my_agent_name/jenkins-agent.jnlp" \
        | grep -o "<argument>[^<]*</argument>" \
        | head -1 \
        | sed 's/<argument>\(.*\)<\/argument>/\1/'
        
    )



java -jar agent.jar "$SECRET" http://localhost:8080/computer/my_agent_name/jenkins-agent.jnlp



