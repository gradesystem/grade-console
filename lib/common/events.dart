part of common;

class PolymerReady {
  const PolymerReady();
}

class ApplicationRenderingReady {
  const ApplicationRenderingReady();
}

class HomeRendered {
  const HomeRendered();
}

class AreasReady {
  const AreasReady();
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
