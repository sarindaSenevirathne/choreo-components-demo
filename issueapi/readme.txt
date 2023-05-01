https://api.asgardeo.io/t/hahack23/oauth2/authorize?response_type=code&redirect_uri=http://localhost:3000&scope=openid+urn:hahack23:issueapidemo:list_issues+urn:hahack23:issueapidemo:create_issue&client_id=ZwsAB4FFH6vUHqMlLprElsmgjq8a


f32bdbc1-36aa-3601-b252-be6760f8f6c0

curl https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=authorization_code&code=e268e67f-f7fa-3cfc-8429-ad3a00163e03&redirect_uri=http://localhost:3000" -H "Authorization: Basic WndzQUI0RkZINnZVSHFNbExwckVsc21nanE4YTpjNG53a005X2pFVDVtQkM1eFlpdFBLOW5kNk1h"



curl -k -X POST https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=client_credentials" -H "Authorization: Basic WndzQUI0RkZINnZVSHFNbExwckVsc21nanE4YTpjNG53a005X2pFVDVtQkM1eFlpdFBLOW5kNk1h"



// fisv app

https://api.asgardeo.io/t/hahack23/oauth2/authorize?response_type=code&redirect_uri=http://localhost:3000&scope=urn:hahack23:accountservice:read_only&client_id=x6nkg3nPi1vLMHWx3gknNy6inJwa

urn:hahack23:accountservice:read_only

http://localhost:3000/?code=702a7962-fbf6-3da2-87cf-495e6c6b3d93

curl https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=authorization_code&code=702a7962-fbf6-3da2-87cf-495e6c6b3d93&redirect_uri=http://localhost:3000" -H "Authorization: Basic eDZua2czblBpMXZMTUhXeDNna25OeTZpbkp3YTpCaDd0dWViMExJcHppa0h5WU5HNGduYmc1dXdh"



https://api.asgardeo.io/t/hahack23/oauth2/authorize?response_type=code&redirect_uri=http://localhost:3000&scope=urn:hahack23:accountservice:read_only&client_id=izSs5jQNBIfbwHlfCfJkn3KM85sa

http://localhost:3000/?code=9557213c-7e00-3b4d-a863-d3b4efcfc6f1

curl https://api.asgardeo.io/t/hahack23/oauth2/token -d "grant_type=authorization_code&code=9557213c-7e00-3b4d-a863-d3b4efcfc6f1&redirect_uri=http://localhost:3000" -H "Authorization: Basic aXpTczVqUU5CSWZid0hsZkNmSmtuM0tNODVzYTpheHEzRzlHVHFWdGw2d2ozTFVNdlgxTVF0NU1h"
