part of deck;


@Injectable()
class DeckPageModel {
  TasksModel tasks;
  TaskExecutions storage;
  
  DeckPageModel(this.tasks, this.storage);
}

@Injectable()
class TaskExecutions extends ListItems<TaskExecution> {
}



