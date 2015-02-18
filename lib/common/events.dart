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
    return bus.on(eventType).where((event)=>
    event is PageEvent && (event as PageEvent).page == page
    || !(event is PageEvent)
    );
  }
  
  void destroy() {
    bus.destroy();
  }
  
}

class PageEvent {
  String page;
  var event;
  
  PageEvent(this.page, this.event);
}

class PolymerReady {
  const PolymerReady();
}

class ApplicationInitialized {
  const ApplicationInitialized();
}

class ApplicationReady {
  const ApplicationReady();
}

typedef ToastCallback(Map data);

class ToastMessage {
  
  String message;
  String type  = "status";
  Function callback;
  
  ToastMessage.alert(this.message, this.callback) : type = "alert";
  
  ToastMessage.info(this.message);
  
}
