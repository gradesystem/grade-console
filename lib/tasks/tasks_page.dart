part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends Polybase {
  
  TasksPage.created() : super.createWith(TasksPageModel);
  
  TasksPageModel get tasksModel => model as TasksPageModel;
  
  TasksModel get tasks => tasksModel.tasksModel;
  TasksQueriesModel get queries => tasksModel.queriesModel;
}


@Injectable()
class TasksPageModel {
  
  TasksModel tasksModel;
  TasksQueriesModel queriesModel;
  
  
  TasksPageModel(this.tasksModel, this.queriesModel);
}

@Injectable()
class TasksModel extends SubPageModel<Task> {
  TasksModel(EventBus bus, TasksService service, Tasks storage) : super(bus, service, storage);
}

@Injectable()
class Tasks extends ListItems<Task> {
}

@Injectable()
class TasksQueriesModel extends SubPageModel<Query> {
  TasksQueriesModel(EventBus bus, TasksQueriesService service, TasksQueries storage) : super(bus, service, storage);
}

@Injectable()
class TasksQueries extends Queries {
}

