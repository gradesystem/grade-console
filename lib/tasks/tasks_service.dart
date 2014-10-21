part of tasks;

@Injectable()
class TasksService extends ListService<Task> {
  TasksService() : super("catalogue", "tasks", toTask);
  
  static Task toTask(Map json) {
    return new Task(json);
  }
}

@Injectable()
class TasksQueriesService extends QueryService {
  TasksQueriesService() : super("catalogue");
}
