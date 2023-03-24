import ballerina/log;
import ballerinax/salesforce;

public function main() returns error? {
    // Create Salesforce client configuration by reading from config file.
    salesforce:ConnectionConfig sfConfig = {
        baseUrl: "https://53w5-dev-ed.my.salesforce.com",
        auth: {
            clientId: "3MVG9l2zHsylwlpSeQAxLupjXz_n14UQe49U8ogEV.Z0MRwzVcjlq0E45TBxTl3eb0WOQ6Ia.GAXlY2BsVT0x",
            refreshUrl: "https://login.salesforce.com/services/oauth2/token",
            clientSecret: "7BC8B00824537A8AC3ACB338AF80C87E2D6B030496854982DE0A5199D9964AF2",
            refreshToken: "5Aep861d1G_LVSxTq1kUSWZCcckFvPVA2nBkwM2kekKL4RLOvEJ5FojYRbuwWoqorSzOghEtSvI8X3tGL6AWb0m"
        }
    };
    // Create Salesforce client.
    salesforce:Client baseClient = check new (sfConfig);
    record {} accountRecord = {
        "Name": "IT World",
        "BillingCity": "Colombo 1"
    };
    salesforce:CreationResponse|error res = baseClient->create("Account", accountRecord);
    if res is salesforce:CreationResponse {
        log:printInfo("Account Created Successfully. Account ID : " + res.id);
    } else {
        log:printError(msg = res.message());
    }
}
