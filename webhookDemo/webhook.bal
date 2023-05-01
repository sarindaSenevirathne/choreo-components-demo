import ballerinax/trigger.shopify;
import ballerina/http;

configurable shopify:ListenerConfig config = ?;

listener http:Listener httpListener = new(8090);
listener shopify:Listener webhookListener =  new(config,httpListener);

service shopify:OrdersService on webhookListener {
  
    remote function onOrdersCreate(shopify:OrderEvent event ) returns error? {
      //Not Implemented
    }
    remote function onOrdersCancelled(shopify:OrderEvent event ) returns error? {
      //Not Implemented
    }
    remote function onOrdersFulfilled(shopify:OrderEvent event ) returns error? {
      //Not Implemented
    }
    remote function onOrdersPaid(shopify:OrderEvent event ) returns error? {
      //Not Implemented
    }
    remote function onOrdersPartiallyFulfilled(shopify:OrderEvent event ) returns error? {
      //Not Implemented
    }
    remote function onOrdersUpdated(shopify:OrderEvent event ) returns error? {
      //Not Implemented
    }
}

service /ignore on httpListener {}