part of common;

class ApplicationReady {
  const ApplicationReady();
}

class ApplicationRenderingReady {
  const ApplicationRenderingReady();
}

class AreasReady {
  const AreasReady();
}

class HomeRendered {
  const HomeRendered();
}

typedef ToastCallback(Map data);

class ToastMessage {
  
  String message;
  String type  = "status";
  Function callback;
  
  ToastMessage.alert(this.message, this.callback) : type = "alert";
  
  ToastMessage.info(this.message);
  
}
