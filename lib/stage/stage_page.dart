part of stage;

@CustomTag("stage-page") 
class StagePage extends Polybase {
  
  @observable
  int subpage = 0;
  
  @observable
  StageQueries queries = new StageQueries();
  
  void onMenuItemSelected(event, detail, target) {
    switch (detail) {
      case 'datasets': subpage = 0; break;
      case 'queries': subpage = 1; break;
    }
  }
  
  StagePage.created() : super.createWith(StagePageModel);
  
  void refresh() {
    stageModel.loadAll();
  }
  
  StagePageModel get stageModel => model as StagePageModel;
  
  StageDatasets get datasets => stageModel.storage;
}

@Injectable()
class StagePageModel extends PageModel<Dataset> {
   StagePageModel(EventBus bus, StageService service, StageDatasets storage) : super(bus, service, storage);
}

@Injectable()
class StageDatasets extends Datasets {
}

class StageQueries extends Queries {
}

