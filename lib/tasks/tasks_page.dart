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
  TasksService service;
  TasksDatasets storage;
   
   TasksPageModel(this.service, this.storage,  EventBus bus) {
     bus.on(ApplicationReady).listen((_) {
       loadAll();
     });
   }
  
   void loadAll() {
     storage.loading = true;
     storage.selected = null;
     service.getAll().then(_setData);
     
   }
   
   void _setData(List<Dataset> graphs) {

     //simulate slowness
     new Timer(new Duration(seconds: 1), (){
       storage.data.clear();
       storage.data.addAll(graphs);
       storage.loading = false;
     });
     
   }
 }

 @Injectable()
 class TasksDatasets extends Datasets {
   
 }
