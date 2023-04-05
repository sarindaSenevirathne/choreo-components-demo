import ballerina/http;
import ballerina/log;

type Category record {
    int id;
    string name;
};

type TagsItem record {
    int id;
    string name;
};

type Pets readonly & record {|
    string id;
    Category category;
    string name;
    string[] photoUrls;
    TagsItem[] tags;
    string status;
|};

configurable int port = 8080;

// type Pets readonly & record {|
//     string id;
//     string title;
//     string artist;
//     decimal price;
// |};

table<Pets> key(status) pets = table [
    // {id: "available", title: "Blue Train", artist: "John Coltrane", price: 56.99},
    // {id: "pending", title: "Jeru", artist: "Gerry Mulligan", price: 17.99},
    // {id: "sold", title: "Sarah Vaughan and Clifford Brown", artist: "Sarah Vaughan", price: 39.99}
    {
        "id": "9223372036854255000",
        "category": {"id": 0, "name": "string"},
        "name": "doggie",
        "photoUrls": ["string"],
        "tags": [{"id": 0, "name": "string"}],
        "status": "available"
    }
];

table<Pets> key(id) petsIds = table [
    // {id: "available", title: "Blue Train", artist: "John Coltrane", price: 56.99},
    // {id: "pending", title: "Jeru", artist: "Gerry Mulligan", price: 17.99},
    // {id: "sold", title: "Sarah Vaughan and Clifford Brown", artist: "Sarah Vaughan", price: 39.99}
    {
        "id": "9223372036854255000",
        "category": {"id": 0, "name": "string"},
        "name": "doggie",
        "photoUrls": ["string"],
        "tags": [{"id": 0, "name": "string"}],
        "status": "available"
    }
];

service / on new http:Listener(9090) {

    resource function get pet/findByStatus/[string status](@http:Header {name: "custom-header"} string? header) returns Pets|http:NotFound {
        log:printInfo("Custom header: " + <string>header);
        Pets? pet = pets[status];
        if pet is () {
            return http:NOT_FOUND;
        } else {
            return pet;
        }
    }
    resource function get v2/pet/findByStatus(@http:Header {name: "x-jwt-assertion"} string? jwtToken, @http:Header {name: "custom-header"} string? header, string status = "available") returns Pets|http:NotFound {
        
        if (header is string) {
            log:printInfo("Custom header: " + <string>header);
        }
        if (jwtToken is string) {
            log:printInfo("JWT header: " + <string>jwtToken);
        }
        //log:printInfo("Custom header: " + <string>header);
        Pets? pet = pets[status];
        if pet is () {
            return http:NOT_FOUND;
        } else {
            return pet;
        }

    }

    resource function get v4/pet/findByStatus(@http:Header {name: "x-jwt-assertion"} string? jwtToken, @http:Header {name: "custom-header"} string? header, string status = "available") returns Pets|http:NotFound {
        log:printInfo("JWT header: " + <string>jwtToken);
        if (header is string) {
            log:printInfo("Custom header: " + <string>header);
        }
        //log:printInfo("Custom header: " + <string>header);
        Pets? pet = pets[status];
        if pet is () {
            return http:NOT_FOUND;
        } else {
            return pet;
        }
    }

    resource function get pet/[string id](@http:Header {name: "x-jwt-assertion"} string? jwtToken, @http:Header {name: "Authorization"} string? auth,@http:Header {name: "custom-header"} string? header,@http:Header {name: "abcIDPToken"} string? abcIDPToken) returns Pets|http:NotFound {
        if (header is string) {
            log:printInfo("Custom header: " + <string>header);
        }
        //log:printInfo("Custom header: " + <string>header);
        if (jwtToken is string) {
            log:printInfo("JWT header: " + <string>jwtToken);
        }

        if (auth is string) {
            log:printInfo("auth header: " + <string>auth);
        }

        if (abcIDPToken is string) {
            log:printInfo("abcIDPToken header: " + <string>abcIDPToken);
        }

        Pets? pet = petsIds[id];
        if pet is () {
            return http:NOT_FOUND;
        } else {
            return pet;
        }
    }

}
