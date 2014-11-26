part of deck;



@Injectable()
class DeckPageModel extends SubPageModel<TaskExecution> {
  TasksModel tasks;
  
  DeckPageModel(this.tasks, EventBus bus, TaskExecutionsService service, TaskExecutions storage) : super(bus, service, storage);
}

@Injectable()
class TaskExecutions extends ListItems<TaskExecution> {
}



