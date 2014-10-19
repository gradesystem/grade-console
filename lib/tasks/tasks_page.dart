part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends Polybase {
  TasksPage.created() : super.createWith(TasksPageModel);
  
  void refresh() {
    tasksModel.loadAll();
  }
  
  TasksPageModel get tasksModel => model as TasksPageModel;
  
  Tasks get tasks => tasksModel.storage;
  
  make_editable() {
    this.$['details'].editable=true;
  }
}

@Injectable()
class TasksPageModel extends PageModel<Task> {
  TasksPageModel(EventBus bus, TasksService service, Tasks storage) : super(bus, service, storage);
}

