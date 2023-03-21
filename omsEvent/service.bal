import ballerina/ftp;
import ballerina/log;
import ballerina/io;

listener ftp:Listener remoteServer = check new ({
    protocol: ftp:SFTP,
    host: "ftp.support.wso2.com",
    auth: {
        credentials: {
            username: "rosbanksub",
            password: "pAa.U!Nb02jds*z6$0i-"
        }
    },
    port: 22,
    path: "/rosbanksub/in/",
    pollingInterval: 1,
    fileNamePattern: "(.*).json"
});

service on remoteServer {
    remote function onFileChange(ftp:WatchEvent & readonly fileEvent, ftp:Caller caller)  {
        log:printInfo("###file event path: " , event=fileEvent.toString());
        foreach ftp:FileInfo addedFile in fileEvent.addedFiles {
            log:printInfo("Added file path: " + addedFile.path);
            stream<byte[] & readonly, io:Error?> fileStream = check caller->get(addedFile.pathDecoded);
            json|error j = fromBytesToJson(fileStream);
            io:println(j);
        } on fail var e {
            error err = e;
            log:printError("Error occurred while reading the file", err = err.toString());
        }
        foreach string deletedFile in fileEvent.deletedFiles {
            log:printInfo("Deleted file path: " + deletedFile);
        }
    }

}

function fromBytesToJson(stream<byte[] & readonly, io:Error?> fileStream) returns json|error {
    byte[] bytes = [];
    check fileStream.forEach(function(byte[] & readonly block) {
        bytes.push(...block);
    });
    string s = check string:fromBytes(bytes);
    json j = check s.fromJsonString();
    return j;
}