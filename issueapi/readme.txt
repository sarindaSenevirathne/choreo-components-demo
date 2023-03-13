https://api.asgardeo.io/t/hahack23/oauth2/authorize?response_type=code&redirect_uri=http://localhost:3000&scope=openid+urn:hahack23:issueapidemo:list_issues+urn:hahack23:issueapidemo:create_issue&client_id=ZwsAB4FFH6vUHqMlLprElsmgjq8a


http://localhost:3000/?code=3a496b1d-bba7-39bf-be41-e8404f8dc2f6&session_state=7e05b4bdd930ddd92c2267aeee3b32274fc3ba2b93b3e1e9b9f8b8154ffa8d17.2w1-8CUJBlkLf2kmqpZ1GA

curl https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=authorization_code&code=3a496b1d-bba7-39bf-be41-e8404f8dc2f6&redirect_uri=http://localhost:3000" -H "Authorization: Basic WndzQUI0RkZINnZVSHFNbExwckVsc21nanE4YTpjNG53a005X2pFVDVtQkM1eFlpdFBLOW5kNk1h"

curl -k -X POST https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=client_credentials" -H "Authorization: Basic WndzQUI0RkZINnZVSHFNbExwckVsc21nanE4YTpjNG53a005X2pFVDVtQkM1eFlpdFBLOW5kNk1h"