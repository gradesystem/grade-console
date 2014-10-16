part of tasks;

@CustomTag("task-details") 
class TaskDetails extends PolymerElement with Filters {
  
  @published
  Dataset item;
  
  TaskDetails.created() : super.created();
  
}