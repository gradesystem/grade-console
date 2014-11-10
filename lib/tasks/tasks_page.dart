part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends Polybase {
  
  TasksPage.created() : super.createWith(TasksPageModel);
  
  TasksPageModel get tasksModel => model as TasksPageModel;
  
  TasksModel get tasks => tasksModel.tasksModel;
  TasksQueriesModel get queries => tasksModel.queriesModel;
  TasksEndpointsModel get endpoints => tasksModel.endpointsModel;
}

