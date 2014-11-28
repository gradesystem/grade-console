part of tasks;

@CustomTag("task-execution")
class TaskExecutionView extends View with HasTaskIcons {
  
  @published
  TaskExecution execution;
  
  TaskKeys TK = const TaskKeys();
  TaskExecutionKeys K = const TaskExecutionKeys();

  List<String> statuses;
  
  TaskExecutionView.created() : super.created() {
    statuses = [K.status_submitted,K.status_started,K.status_transformed, K.status_modified,K.status_completed];
  }
  
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
    
    //humber of relevant states depends on op
    var length = getMap(execution,K.task)[TK.op]==TK.publish_op? statuses.length : statuses.length-1; 
    
    progress = (100/length)*(statuses.indexOf(status)+1);
   
  }
 
}
