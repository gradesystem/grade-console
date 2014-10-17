part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends Polybase {
  
  @published
  bool editable = false;
  
  TasksPage.created() : super.createWith(TasksPageModel);
  
  void refresh() {
    tasksModel.loadAll();
  }
  
  void onEdit() {
    print('ON EDIT');
    editable = !editable;
  }
  
  TasksPageModel get tasksModel => model as TasksPageModel;
  
  Tasks get tasks => tasksModel.storage;
}

@Injectable()
class TasksPageModel extends PageModel<Task> {
  TasksPageModel(EventBus bus, TasksService service, Tasks storage) : super(bus, service, storage);
}

