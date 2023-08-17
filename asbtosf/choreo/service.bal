
import ballerina/log;
import ballerinax/trigger.asb;
import ballerinax/salesforce;

configurable string ASB_CONNECTION_STRING=?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;
configurable string baseUrl = ?;

asb:ListenerConfig configuration = {
    connectionString: ASB_CONNECTION_STRING
};

listener asb:Listener asbListener = new (configuration);



@asb:ServiceConfig {
    queueName: "integration-queue",
    peekLockModeEnabled: true,
    maxConcurrency: 1,
    prefetchCount: 10,
    maxAutoLockRenewDuration: 300
}

service asb:MessageService on asbListener {

    isolated remote function onMessage(asb:Message message, asb:Caller caller) returns error? {
        log:printInfo("Reading Received Message ##### :");
        if message.body is byte[] {

            string s = check string:fromBytes(<byte[]>message.body);
            log:printInfo("Received message", message = s);
            json accountmsg = check s.fromJsonString();
            
            salesforce:ConnectionConfig sfConfig = {
                baseUrl: baseUrl,
                auth: {
                    clientId: clientId,
                    clientSecret: clientSecret,
                    refreshToken: refreshToken,
                    refreshUrl: refreshUrl
                }
            };

            record {} accountRecord = {
                "Name":check accountmsg.fieldAndValue.name,
                "description": check accountmsg.fieldAndValue.description,
                "phone": check accountmsg.fieldAndValue.phone,
                "Site": check accountmsg.fieldAndValue.Site
            };

            salesforce:Client baseClient = check new (sfConfig);
            salesforce:CreationResponse res = check baseClient->create("Account", accountRecord);
            log:printInfo("Created Account", recordId = res);

        }
    }

    isolated remote function onError(asb:ErrorContext context, error 'error) returns error? {
        // Write your error handling logic here
    }
};

