part of tasks;

@Injectable()
class TasksService extends DatasetService {
  TasksService(HttpService http) : super(http, "catalogue", "tasks");
}
