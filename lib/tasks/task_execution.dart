part of tasks;

@CustomTag("task-execution")
class TaskExecutionView extends View {
  
  @published
  TaskExecution execution;
  
  TaskKeys TK = const TaskKeys();
  TaskExecutionKeys K = const TaskExecutionKeys();
  
  Map<String,String> icons;

  List<String> statuses;
  
  TaskExecutionView.created() : super.created() {
    
    statuses = [K.status_submitted,K.status_started,K.status_transformed, K.status_modified,K.status_completed];
    
    icons={K.status_submitted : "cloud-upload", 
           K.status_started : "cloud",
           K.status_transformed : "cloud",
           K.status_modified : "cloud",
           K.status_completed:"cloud-done",
           K.status_failed:"warning"};
  
  }
  
  @observable
  String icon;
  
  @observable
  num progress = 0;
  
  @observable
  String source;
  
  @observable
  String target;
  
  @ObserveProperty('execution')
  update() {
    
    source = getMap(execution,K.source)[Endpoint.name_field];
    target = getMap(execution,K.target)[Endpoint.name_field];
        
    String status = get(execution,K.status);
    
    if (status==null)
      return;
    
    icon = icons[status];
    
    //humber of relevant states depends on op
    var length = getMap(execution,K.task)[TK.op]==TK.publish_op? statuses.length : statuses.length-1; 
    
    progress = (100/length)*(statuses.indexOf(status)+1);
   
  }
 
}
