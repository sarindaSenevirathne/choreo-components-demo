https://api.asgardeo.io/t/hahack23/oauth2/authorize?response_type=code&redirect_uri=http://localhost:3000&scope=openid+urn:hahack23:issueapidemo:list_issues+urn:hahack23:issueapidemo:create_issue&client_id=ZwsAB4FFH6vUHqMlLprElsmgjq8a


f32bdbc1-36aa-3601-b252-be6760f8f6c0

curl https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=authorization_code&code=0a4226c7-d1ac-39ff-8188-1ef5ab77b3c4&redirect_uri=http://localhost:3000" -H "Authorization: Basic WndzQUI0RkZINnZVSHFNbExwckVsc21nanE4YTpjNG53a005X2pFVDVtQkM1eFlpdFBLOW5kNk1h"

curl -k -X POST https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=client_credentials" -H "Authorization: Basic WndzQUI0RkZINnZVSHFNbExwckVsc21nanE4YTpjNG53a005X2pFVDVtQkM1eFlpdFBLOW5kNk1h"