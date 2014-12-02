part of tasks;

@CustomTag("task-execution")
class TaskExecutionView extends View with HasTaskIcons {
  
  @published
  TaskExecution execution;
  
  TaskKeys TK = const TaskKeys();
  TaskExecutionKeys K = const TaskExecutionKeys();
  
  TaskExecutionView.created() : super.created();
  
  @observable
  num progress = 0;
  
  @observable
  String source;
  

  @observable
  String icon;

  @observable
  String target;
  
  @ObserveProperty('execution')
  update() {
    
    source = getMap(execution,K.source)[Endpoint.K.name];
    target = getMap(execution,K.target)[Endpoint.K.name];
        
    String status = get(execution,K.status);
    
    if (status==null)
      return;
    
    icon = toIcon(status);
    
    //humber of relevant states depends on op
    var length = getMap(execution,K.task)[TK.op]==TK.publish_op? TaskExecutionLists.statuses.length : TaskExecutionLists.statuses.length-1; 
    
    progress = (100/length)*(TaskExecutionLists.statuses.indexOf(status)+1);
   
  }

 
}
