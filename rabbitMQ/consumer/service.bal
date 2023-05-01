import ballerinax/rabbitmq;
import ballerina/log;

type person record {
    string name;
    int age;
};

configurable string MQ_HOST = ?;
configurable int MQ_PORT = ?;

listener rabbitmq:Listener channelListener = new (MQ_HOST, MQ_PORT);

public type StringMessage record {|
    *rabbitmq:AnydataMessage;
    string content;
|};

 @rabbitmq:ServiceConfig {
      queueName: "personQ",
      autoAck: false
}
service rabbitmq:Service on channelListener {
    remote function onMessage(StringMessage message) {
        log:printInfo("received message from personQ.", message = message.content);
    }
}