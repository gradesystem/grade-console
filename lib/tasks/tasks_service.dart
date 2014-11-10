
part of tasks;

final String _path = "catalogue";

@Injectable()
class TasksService extends ListService<Task> {
  TasksService() : super(_path, "tasks", "task", toTask);
  
  static Task toTask(Map json) {
    return new Task(json);
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
