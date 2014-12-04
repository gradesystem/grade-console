part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends Polybase {
  
  TasksPage.created() : super.createWith(TasksPageModel);
  
  TasksPageModel get tasksPageModel => model as TasksPageModel;
  
  TasksModel get tasks => tasksPageModel.tasksModel;
  TasksQueriesModel get queries => tasksPageModel.queriesModel;
  EndpointSubPageModel get endpoints => tasksPageModel.endpointsModel;
}

