part of deck;

@Injectable()
class DeckPageModel  {
  
  EventBus bus;
  
  TasksModel tasks;
  TaskExecutionsService executionsService;
  RunningTasks storage;

  DeckPageModel(this.bus,this.storage, this.tasks, this.executionsService) {
     bus.on(ApplicationReady).listen((_) {
       loadAll();
     });
   }
  
   void loadAll() {
     storage.loading = true;
     storage.selected = null;
     executionsService.getAll().then(_setData).catchError((e)=>_onError(e, loadAll));
     
   }
   
   void _setData(List<TaskExecution> items) {

     storage.data.clear();
     storage.data.addAll(items.map((TaskExecution te)=> new RunningTask.fromExecution(te)));
     storage.loading = false;
     
   }
   
   
   void _onError(e, callback) {
     storage.data.clear();
     storage.loading = false;
     bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
   }
}

@Injectable()
class RunningTasks extends ListItems<RunningTask> {
}



