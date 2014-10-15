part of tasks;

@CustomTag("tasks-page") 
class TasksPage extends Polybase {
  TasksPage.created() : super.createWith(TasksPageModel);
  
  void refresh() {
    tasksModel.loadAll();
  }
  
  TasksPageModel get tasksModel => model as TasksPageModel;
  
  TasksDatasets get datasets => tasksModel.storage;
}

@Injectable()
class TasksPageModel {
  
  EventBus bus;
  TasksService service;
  TasksDatasets storage;
   
   TasksPageModel(this.bus, this.service, this.storage) {
     bus.on(ApplicationReady).listen((_) {
       loadAll();
     });
   }
  
   void loadAll() {
     storage.loading = true;
     storage.selected = null;
     service.getAll().then(_setData).catchError((e)=>_onError(e, loadAll));
     
   }
   
   void _setData(List<Dataset> graphs) {

     //simulate slowness
     new Timer(new Duration(seconds: 1), (){
       storage.data.clear();
       storage.data.addAll(graphs);
       storage.loading = false;
     });
     
   }
   
   void _onError(e, callback) {
     log.severe("service error", e);
     storage.data.clear();
     storage.loading = false;
     bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
   }
 }

 @Injectable()
 class TasksDatasets extends Datasets {
   
 }
