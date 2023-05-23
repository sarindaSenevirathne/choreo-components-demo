import ballerinax/trigger.google.sheets;
import ballerina/http;
import ballerina/log;

configurable sheets:ListenerConfig config = ?;

listener http:Listener httpListener = new(8090);
listener sheets:Listener webhookListener =  new(config,httpListener);

service sheets:SheetRowService on webhookListener {
  
    remote function onAppendRow(sheets:GSheetEvent payload ) returns error? {
      log:printInfo("Row Appended",event=payload);
      //Not Implemented
    }
    remote function onUpdateRow(sheets:GSheetEvent payload ) returns error? {
      //Not Implemented
      log:printInfo("Row update",event=payload);
    }
}

service /ignore on httpListener {}