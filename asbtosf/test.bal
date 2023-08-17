import ballerina/log;

public function main() returns error? {
    string ac = "\n{\n  \"sObject\":\"Account\",\n  \"fieldAndValue\": {\n  \"name\": \"Engineers\",\n  \"description\":\"This Account belongs to WSO2\",\n  \"phone\" :\"409-987-1235\",\n  \"Site\":\"www.wso2.com\"\n}\n}";
    json accountmsg = check ac.fromJsonString();
    log:printInfo("mesage", test=accountmsg);
    //   record {} accountRecord = {
    //             "Name":check accountmsg.fieldAndValue.name,
    //             "description": check accountmsg.fieldAndValue.description,
    //             "phone": check accountmsg.fieldAndValue.phone,
    //             "Site": check accountmsg.fieldAndValue.Site
    //         };

    string a = check accountmsg.fieldAndValue.name;
    log:printInfo("mesage", test=a);

}
