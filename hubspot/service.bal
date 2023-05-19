import ballerina/http;
import ballerinax/hubspot.crm.contact;
import ballerina/log;

configurable string HubSpotClientId = "c708cb7b-d611-45ee-a4b7-034f5c536718";
configurable string HubSpotClientSecret = "318db732-a769-4449-abdd-4f1ac45f3f98";
configurable string HubSpotRefreshToken = "a1331390-85ba-47bc-b915-e67c26f053a7";

const string hubspotTokenEndpoint = "https://api.hubapi.com/oauth/v1/token";

service / on new http:Listener(9090) {

    // This function responds with `string` value `Hello, World!` to HTTP GET requests.
    resource function get eventTest() returns string|error {

        contact:Client hubspotEndpoint = check new ({
            auth: {
                refreshUrl: hubspotTokenEndpoint,
                refreshToken: HubSpotRefreshToken,
                clientId: HubSpotClientId,
                clientSecret: HubSpotClientSecret,
                credentialBearer: "POST_BODY_BEARER"
            }
        });
        string email = "demo123@gmail.com";

        contact:SimplePublicObjectInput contactPayload = {
            "properties": {
                "email": email
            }
        };

        contact:SimplePublicObject|error hubspotResponse = hubspotEndpoint->create(contactPayload);
        log:printError(string `creation post message ##### done 3`);
        log:printError(string `creation response : ${(check hubspotResponse).toString()}`);
        if hubspotResponse is error {
            log:printError(string `Hubspot account creation call failed! - ${hubspotResponse.toString()}`);
        } else {
            log:printInfo(string `HubSpot contact creation request sent for the email: ${email}`);
            log:printInfo(hubspotResponse.toString());
        }

        return "Hello, travel contract!";
    }

}

