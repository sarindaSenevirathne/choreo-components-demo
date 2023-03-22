
import ballerina/ftp;
import ballerina/io;
import ballerina/log;
import ballerina/file;
import ballerinax/rabbitmq;

configurable string MQ_HOST = ?;
configurable int MQ_PORT = ?;
configurable string FTP_HOST = ?;
configurable int FTP_PORT = ?;
configurable string FTP_USER = ?;
configurable string FTP_PASSWORD = ?;
configurable string FTP_PATH = ?;


listener ftp:Listener secureRemoteServer = check new ({
    protocol: ftp:SFTP,
    host: FTP_HOST,
    auth: {
        credentials: {
            username: FTP_USER,
            password: FTP_PASSWORD
        }
    },
    port: FTP_PORT,
    path: FTP_PATH,
    pollingInterval: 1,
    fileNamePattern: "(.*).csv"
});


service "Covid19UpdateDownloader" on secureRemoteServer {

    private rabbitmq:Client rabbitmqClient;
    //private ftp:Client sftpClient = check new(sftpClientConfig);

    public function init() returns error? {
        self.rabbitmqClient = check new (MQ_HOST, MQ_PORT);
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
                error? writeResult = io:fileWriteBlocksFromStream("/tmp/"+fileName, fileStream, option = io:APPEND);
                error? fileCloseResult = fileStream.close();
                 log:printInfo("#2");
                if writeResult is error || fileCloseResult is error {
                    continue;
                }
                 log:printInfo("#3");
                _ = start self.publishToRabbitmq("/tmp/"+fileName);
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
                error? result = self.rabbitmqClient->publishMessage({
                    content: message.toBytes(),
                    routingKey: "InfectionQueue"
                });
                if result is error {
                    log:printError("Error while trying to publish to the queue.");
                }
            };
        check csvStream.close();
        check file:remove(newFileName);
    }

    // function fileStreamingCVS(stream<byte[] & readonly, io:Error?> fileStream) returns json|error {
    //     byte[] bytes = [];
    //     check fileStream.forEach(function(byte[] & readonly block) {
    //         bytes.push(...block);
    //     });
    //     string s = check string:fromBytes(bytes);
    //     //s.fromBalString().
    //     //stream<string[], io:Error?> stringStream = s.toStream();
    //     //json j = check s.fromJsonString();
    //     //return j;y
    // }

}
