part of stage;

@CustomTag("stage-page") 
class StagePage extends Polybase {
  StagePage.created() : super.createWith(StagePageModel);
  
  void refresh() {
    stageModel.loadAll();
  }
  
  StagePageModel get stageModel => model as StagePageModel;
  
  StageDatasets get datasets => stageModel.storage;
}

@Injectable()
class StagePageModel {
   StageService service;
   StageDatasets storage;
   
   StagePageModel(this.service, this.storage,  EventBus bus) {
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
 class StageDatasets extends Datasets {
   
 }

