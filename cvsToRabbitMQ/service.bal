
import ballerina/ftp;
import ballerina/io;
import ballerina/log;
import ballerina/file;
import ballerinax/rabbitmq;

configurable string MQ_HOST = ?;
configurable int MQ_PORT = ?;

listener ftp:Listener secureRemoteServer = check new ({
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
    fileNamePattern: "(.*).csv"
});

//public final rabbitmq:Client statePersistProducer = check new (rabbitmq:DEFAULT_HOST, rabbitmq:DEFAULT_PORT);
public final rabbitmq:Client statePersistProducer = check new (MQ_HOST, MQ_PORT);

service "Covid19UpdateDownloader" on secureRemoteServer {

    private rabbitmq:Client rabbitmqClient;
    //private ftp:Client sftpClient = check new(sftpClientConfig);

    public function init() returns error? {
        self.rabbitmqClient = check new(MQ_HOST, MQ_PORT);
        check self.rabbitmqClient->queueDeclare("InfectionQueue", {durable: true, autoDelete: false});
        log:printInfo("Initialized the process job.");
    }

    remote function onFileChange(ftp:WatchEvent & readonly event, ftp:Caller caller) returns error? {
        foreach ftp:FileInfo addedFile in event.addedFiles {
            string fileName = addedFile.name.clone();
            //log:printInfo("Added file: " + fileName);
            stream<byte[] & readonly, io:Error?>|error fileStream = check caller->get(addedFile.pathDecoded);
            if fileStream is stream<byte[] & readonly, io:Error?> {
                log:printInfo("#1");
                error? writeResult = io:fileWriteBlocksFromStream(fileName, fileStream, option = io:APPEND);
                error? fileCloseResult = fileStream.close();
                 log:printInfo("#2");
                if writeResult is error || fileCloseResult is error {
                    continue;
                }
                 log:printInfo("#3");
                _ = start self.publishToRabbitmq(fileName);
            } else {
                log:printInfo(fileStream.message());
            }
        }
    }

    private function publishToRabbitmq(string newFileName) returns error? {
        log:printInfo("Going to process new file: " + newFileName);
        stream<string[], io:Error?> csvStream = check io:fileReadCsvAsStream(newFileName);
        _ = check from var entry in csvStream
        where entry[2] != "" && entry[3] != "" && entry[4] != ""
        do {
            log:printInfo("Processing new file: " + newFileName);
            json messageJson = {country: entry[2], date: entry[3], totalCases: entry[4]};
            string message = messageJson.toJsonString();
            log:printInfo("Going to publish message: " + message);
            error? result = self.rabbitmqClient->publishMessage({content: message.toBytes(),
                routingKey: "InfectionQueue"});
            if result is error {
                log:printError("Error while trying to publish to the queue.");
            }
        };
        check csvStream.close();
        check file:remove(newFileName);
    }

}
