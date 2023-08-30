import ballerinax/kafka;
import ballerina/log;

configurable string groupId = ?;
configurable string orders = ?;
configurable string paymentSuccessOrders =?;
configurable decimal pollingInterval = 1;
configurable string kafkaEndpoint = ?;
configurable string apikey = ?;
configurable string apiSecret = ?;

//configurable string kafkaEndpoint = "2.tcp.ngrok.io:14890";

// public type Order readonly & record {|
//     int id;
//     string desc;
//     PaymentStatus paymentStatus;
// |};

//{"ordertime": 1497014222380,"orderid": 18,"itemid": "Item_184","paymentStatus": "SUCCESS","address": {"city": "Mountain View","state": "CA","zipcode": 94041}}

public enum PaymentStatus {
    SUCCESS,
    FAIL
}

public type Order record {
    string itemid;
    boolean isValid=true;
    record {
        int zipcode;
        string city;
        string state;
    } address;
    int orderid;
    decimal ordertime;
    PaymentStatus paymentStatus?;
};

listener kafka:Listener kafkaListener = new (kafkaEndpoint, consumerConfigs);

final kafka:ConsumerConfiguration consumerConfigs = {
    groupId: groupId,
    topics: [orders],
    offsetReset: kafka:OFFSET_RESET_EARLIEST,
    auth: {username: apikey, password: apiSecret},
    securityProtocol: kafka:PROTOCOL_SASL_SSL,
    pollingInterval
};

final kafka:ProducerConfiguration producerConfigs ={
       auth: {username: apikey, password: apiSecret},
    securityProtocol: kafka:PROTOCOL_SASL_SSL
};

service on kafkaListener {
    private final kafka:Producer orderProducer;

    function init() returns error? {
        self.orderProducer = check new (kafkaEndpoint,producerConfigs);
    }

    remote function onConsumerRecord(Order[] orders) returns error? {
        log:printInfo("Received orders: " + orders.toString());
        check from Order 'order in orders
            where 'order.paymentStatus == SUCCESS
            do {
                log:printInfo("SUCCESS orders: " + orders.toString());
                check self.orderProducer->send({
                    topic: paymentSuccessOrders,
                    value: 'order
                });
            };
    }
}