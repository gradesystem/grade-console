
part of tasks;

final String _path = "catalogue";

@Injectable()
class TasksService extends EditableListService<Task> {
  TasksService() : super(_path, "tasks", "task", toTask);
  
  static Task toTask(Map json) {
    return new Task.fromBean(json);
  }
}

@Injectable()
class TasksQueriesService extends QueryService {
  TasksQueriesService() : super(_path);
}

@Injectable()
class TasksEndpointsService extends EndpointsService {
  TasksEndpointsService() : super(_path);
}

