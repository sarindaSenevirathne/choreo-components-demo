import ballerinax/trigger.salesforce;


configurable salesforce:ListenerConfig config = ?;


listener salesforce:Listener webhookListener =  new(config);

service salesforce:RecordService on webhookListener {
  
    remote function onCreate(salesforce:EventData payload ) returns error? {
      //Not Implemented
    }
    remote function onUpdate(salesforce:EventData payload ) returns error? {
      //Not Implemented
    }
    remote function onDelete(salesforce:EventData payload ) returns error? {
      //Not Implemented
    }
    remote function onRestore(salesforce:EventData payload ) returns error? {
      //Not Implemented
    }
}

