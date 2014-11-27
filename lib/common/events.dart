part of common;

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

class TaskLaunched {
  const TaskLaunched();
}
