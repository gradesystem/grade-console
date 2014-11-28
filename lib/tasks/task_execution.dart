part of tasks;

@CustomTag("task-execution")
class TaskExecutionView extends View {
  
  @published
  TaskExecution execution;
  
  TaskKeys TK = const TaskKeys();
  TaskExecutionKeys K = const TaskExecutionKeys();
  TaskExecutionLists KL;
  
  Map<String,String> icons;

  TaskExecutionView.created() : super.created() {
    
   KL = new TaskExecutionLists(K);
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
    var length = getMap(execution,K.task)[TK.op]==TK.publish_op? KL.statuses.length : KL.statuses.length-1; 
    
    progress = (100/length)*(KL.statuses.indexOf(status)+1);
   
  }
 
}
