import ballerina/http;

type Test record {
    record {
        string id;
        record {
            string id;
            record {
                int smLevel?;
                string appId?;
                string src?;
                string height?;
                string width?;
            } config?;
        }[] requestPlugin;
        (anydata[]|record {
            string id ;
            record {
                int smLevel? ;
                string appId? ;
                string src? ;
                string height? ;
                string width? ;
            } config;
        }[]) responsePlugin;
        string basePath?;
    }[] test;
};

service /foo on new http:Listener(9090) {
    resource function get .() returns error? {
    }
}
