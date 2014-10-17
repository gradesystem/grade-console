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
class StagePageModel extends PageModel<Dataset> {
   StagePageModel(EventBus bus, StageService service, StageDatasets storage) : super(bus, service, storage);
}

@Injectable()
class StageDatasets extends Datasets {
}

