
import ballerina/log;
import ballerinax/trigger.asb;
import ballerinax/salesforce;

asb:ListenerConfig configuration = {
    connectionString: "Endpoint=sb://demodushan.servicebus.windows.net/;SharedAccessKeyName=demo;SharedAccessKey=jkmWWYSIazQtNaO68O4q3hU+c3nEMuDRS+ASbLVQx5k="
};

listener asb:Listener asbListener = new (configuration);

configurable string clientId = "3MVG9l2zHsylwlpSeQAxLupjXz_n14UQe49U8ogEV.Z0MRwzVcjlq0E45TBxTl3eb0WOQ6Ia.GAXlY2BsVT0x";
configurable string clientSecret = "7BC8B00824537A8AC3ACB338AF80C87E2D6B030496854982DE0A5199D9964AF2";
configurable string refreshToken = "5Aep861d1G_LVSxTq1kUSWZCcckFvPVA2nBkwM2kekKL4RLOvEJ5FojYRbuwWoqorSzOghEtSvI8X3tGL6AWb0m";
configurable string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
configurable string baseUrl = "https://53w5-dev-ed.my.salesforce.com";

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

