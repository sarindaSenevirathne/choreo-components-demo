import ballerina/http;
import ballerinax/rabbitmq;
import ballerina/log;

type Person record {
    string name;
    int age;
};

configurable string MQ_HOST = ?;
configurable int MQ_PORT = ?;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {
    private rabbitmq:Client rabbitmqClient;
    # A resource representing a network-accessible API
    # + return - Return Value Description
    public function init() returns error? {
        self.rabbitmqClient = check new (MQ_HOST, MQ_PORT);
        check self.rabbitmqClient->queueDeclare("personQ", {durable: true, autoDelete: false});
        log:printInfo("Initialized the process job.");
    }
    resource function post produce(@http:Payload Person persn) returns error?|http:Created {
        log:printError("produce message to personQ.");
        string message = persn.toJsonString();
        error? result = self.rabbitmqClient->publishMessage({
            content: message.toBytes(),
            routingKey: "personQ"
        });
        if result is error {
            log:printError("Error while trying to publish to the queue.");
        }else{
            return http:CREATED;
        }
    
    }
}
