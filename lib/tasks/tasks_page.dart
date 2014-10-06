part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends Polybase {
  TasksPage.created() : super.createWith(TasksPageModel);
}

@Injectable()
class TasksPageModel {
}

