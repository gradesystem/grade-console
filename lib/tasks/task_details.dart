part of tasks;

@CustomTag("task-details") 
class TaskDetails extends PolymerElement with Filters {
  
  @published
  Task item;
  
  TaskDetails.created() : super.created();
  
}