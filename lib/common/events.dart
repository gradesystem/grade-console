part of common;

@Injectable()
class PageEventBus {
  
  String page;
  EventBus bus;
  
  PageEventBus(this.page, this.bus);
  
  void fireInPage(event) {
    bus.fire(new PageEvent(page, event));
  }
  
  void fire(event) {
    bus.fire(event);
  }
  
  Stream on([Type eventType]) {
    return bus.on()
        //checks if is page specific and in the case if we want it
        .where((event)=>event is PageEvent && (event as PageEvent).page == page || !(event is PageEvent))
        //if necessary extracts the event
        .map((event)=>event is PageEvent?(event as PageEvent).event:event)
        //checks if is listening for the right event type
        .where((event) => eventType == null || event.runtimeType == eventType);
  }
  
  void destroy() {
    bus.destroy();
  }
  
  String toString()=> 'PageEventBus($hashCode) page: $page bus: ${bus.hashCode}';
  
}

class PageEvent {
  String page;
  var event;
  
  PageEvent(this.page, this.event);
  
  String toString()=>'PageEvent page: $page event: $event';
}

class PolymerReady {
  const PolymerReady();
}

class ApplicationInitialized {
  const ApplicationInitialized();
}

class ApplicationNewVersionAvailable {
  const ApplicationNewVersionAvailable();
}

class ApplicationReady {
  const ApplicationReady();
}

class EndpointOperation {
  const EndpointOperation();
}

class GraphOperation {
  const GraphOperation();
}

typedef ToastCallback(Map data);

class ToastMessage {
  
  String message;
  String type  = "status";
  Function callback;
  
  ToastMessage.alert(this.message, this.callback) : type = "alert";
  
  ToastMessage.info(this.message);
  
}
