import ballerinax/trigger.google.sheets;
import ballerina/http;

configurable sheets:ListenerConfig config = ?;

listener http:Listener httpListener = new(8090);
listener sheets:Listener webhookListener =  new(config,httpListener);

service sheets:SheetRowService on webhookListener {
  
    remote function onAppendRow(sheets:GSheetEvent payload ) returns error? {
      //Not Implemented
    }
    remote function onUpdateRow(sheets:GSheetEvent payload ) returns error? {
      //Not Implemented
    }
}

service /ignore on httpListener {}