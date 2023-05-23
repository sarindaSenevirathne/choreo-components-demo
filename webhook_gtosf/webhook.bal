import ballerinax/trigger.salesforce;
import ballerina/log;
import ballerinax/salesforce as sfdc;
import ballerinax/googleapis.sheets;

type GsheetCellValueType int|string|decimal;

const string BASE_URL = "/services/data/v48.0/sobjects/";
const int HEADINGS_ROW = 1;

configurable GSheetOAuth2Config GSheetOAuthConfig = ?;
configurable string spreadsheetId = ?;
configurable string worksheetName = ?;

configurable salesforce:ListenerConfig config = ?;
configurable SalesforceOAuth2Config salesforceOAuthConfig = ?;
configurable string salesforceBaseUrl = ?;
configurable string salesforceObject = ?;

type GSheetOAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://www.googleapis.com/oauth2/v3/token";
};

type SalesforceOAuth2Config record {
    string clientId;
    string clientSecret;
    string refreshToken;
    string refreshUrl = "https://login.salesforce.com/services/oauth2/token";
};

// Salesforce listener configuration parameters
type ListenerConfig record {
    string username;
    string password;
};

listener salesforce:Listener webhookListener = new (config);

service salesforce:RecordService on webhookListener {

    # Description
    #
    # + payload - Parameter Description
    # + return - Return Value Description
    remote function onCreate(salesforce:EventData payload) returns error? {
        log:printInfo("sales force receord was created was created", payload = payload);
        log:printInfo("New record created ####### tested", payload = payload);
        string sobjectId = payload?.metadata?.recordId ?: "";
        string path = string `${BASE_URL}${salesforceObject}/${sobjectId}`;
     
        sfdc:ConnectionConfig sfConfig = {
            baseUrl: salesforceBaseUrl,
            auth: {
                clientId: salesforceOAuthConfig.clientId,
                clientSecret: salesforceOAuthConfig.clientSecret,
                refreshToken: salesforceOAuthConfig.refreshToken,
                refreshUrl: salesforceOAuthConfig.refreshUrl
            }
        };

        sfdc:Client sfdcClient = check new (sfConfig);
        // Get relevent sobject information
        map<json> sobjectInfo = <map<json>>check sfdcClient->getRecord(path);

        // Populate column names, values for GSheet
        string[] columnNames = [];
        GsheetCellValueType[] values = [];
        foreach [string, json] [key, value] in sobjectInfo.entries() {
            columnNames.push(key);
            values.push(value.toString());
        }
        sheets:ConnectionConfig spreadsheetConfig = {
            auth: {
                clientId: GSheetOAuthConfig.clientId,
                clientSecret: GSheetOAuthConfig.clientSecret,
                refreshToken: GSheetOAuthConfig.refreshToken,
                refreshUrl: GSheetOAuthConfig.refreshUrl
            }
        };
        sheets:Client gSheetClient = check new (spreadsheetConfig);

        sheets:Row headers = check gSheetClient->getRow(spreadsheetId, worksheetName, HEADINGS_ROW);
        log:printInfo("adding to google sheet", headers = headers);
        
        if headers.values.length() == 0 {
            check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, columnNames);
        }

        check gSheetClient->appendRowToSheet(spreadsheetId, worksheetName, values);
        log:printInfo("appending to success", spreadsheetId = spreadsheetId);
        //log:printInfo(string `${salesforceObject} with Id ${sobjectId} added to spreadsheet successfully`);
        //Not Implemented
    }
    remote function onUpdate(salesforce:EventData payload) returns error? {
        //Not Implemented
    }
    remote function onDelete(salesforce:EventData payload) returns error? {
        //Not Implemented
    }
    remote function onRestore(salesforce:EventData payload) returns error? {
        //Not Implemented
    }
}

