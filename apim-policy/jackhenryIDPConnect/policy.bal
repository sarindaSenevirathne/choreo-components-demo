import ballerina/http;
import choreo/mediation;
import ballerina/mime;
import ballerina/io;
import ballerina/log;

// A mediation policy package consists of 1-3 functions, each corresponding to one of the 3 possible request/response
// flows:
// - In-flow function is applied to a request coming in to a resource in the proxy
// - Out-flow function is applied to the response received from the upstream server before forwarding it to the client
// - Fault-flow function is applied if an error occurs in any of the above 2 flows and the control flow is handed over
//   to the error handling flow
//
// A policy can contain any combination of the above 3 flows. Therefore one can get rid of up to any 2 of the following
// functions. The function names are irrelevant. Therefore one can name them as they see fit.

// The first 2 parameters are required. After the first 2 parameters, one can add arbitrary number of parameters of
// the following types: int, string, float, boolean, decimal. However, all policy functions should have exactly the same
// number and types of these arbitrary parameters.
@mediation:RequestFlow
public function policyNameIn(mediation:Context ctx, http:Request req)
                                returns http:Response|false|error|() {

    final http:Client clientEndpoint = check new ("https://digital.garden-fi.com", httpVersion = http:HTTP_1_1);
    // Sends a POST request to the specified endpoint.
    //base64encode key:secret
    //string encoded = client_id + ":" + client_secret;
    //byte[] inputArr = encoded.toBytes();
    //string encodedString = inputArr.toBase64();

    // json response = check clientEndpoint->post("/a/consumer/api/v0/oidc/token",
    //     {
    //     "grant_type": "authorization_code"
    // },
    //     {
    //     "Authorization": "Basic " + encodedString
    // },
    //     mime:APPLICATION_FORM_URLENCODED

    // );

    string client_id = check req.getHeader("clientId");
    log:printInfo("Header client_id ####", res = client_id);
    string client_secret = check req.getHeader("clientSecret");
    log:printInfo("Header client_secret ####", res = client_secret);
    string redirect_url = check req.getHeader("redirectUrl");
    log:printInfo("Header redirect_url ####", res = redirect_url);
    string code = check req.getHeader("code");
    log:printInfo("Header code ####", res = code);
    string code_verifier = check req.getHeader("codeVerifier");
    log:printInfo("Header code_verifier $$$", res = code_verifier);

    string payload = "client_id=" + client_id + "&client_secret=" + client_secret + "&grant_type=authorization_code" +
                    "&code=" + code + "&redirect_uri=" + redirect_url + "&code_verifier=" + code_verifier;

    http:Request reqidp = new;
    reqidp.setHeader("Content-Type", mime:APPLICATION_FORM_URLENCODED);
    reqidp.setPayload(payload);
    json|http:ClientError response = clientEndpoint->post("/a/consumer/api/v0/oidc/token", reqidp);
    if (response is http:ClientError) {
        log:printInfo("TOKEN RESPONSE FROM THE BE RECEIVED", res_ = response.message());
        return generateResponse("Error in token response", 500);
    }
    string jwt = check response.access_token;
    io:println(response.toString());
    log:printInfo("TOKEN RESPONSE FROM THE BE RECEIVED", res = jwt);
    req.addHeader("Authorization", "Bearer " + jwt);
    return ();
}

function generateResponse(string message, int statusCode) returns http:Response {
    http:Response response = new ();
    response.setTextPayload(message);
    response.statusCode = statusCode;
    return response;
}
