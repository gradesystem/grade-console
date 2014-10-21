part of stage;

@CustomTag("stage-page") 
class StagePage extends Polybase {
  
  
  StagePage.created() : super.createWith(StagePageModel);

  
  StagePageModel get stageModel => model as StagePageModel;
  
  StageDatasetsModel get datasets => stageModel.datasetsModel;
  StageQueriesModel get queries => stageModel.queriesModel;
}

@Injectable()
class StagePageModel {
  
  StageDatasetsModel datasetsModel;
  StageQueriesModel queriesModel;
  
  
  StagePageModel(this.datasetsModel, this.queriesModel);
}

@Injectable()
class StageDatasetsModel extends SubPageModel<Dataset> {
   StageDatasetsModel(EventBus bus, StageService service, StageDatasets storage) : super(bus, service, storage);
}

@Injectable()
class StageDatasets extends Datasets {
}

@Injectable()
class StageQueriesModel extends SubPageModel<Query> {
  StageQueriesModel(EventBus bus, StageQueriesService service, StageQueries storage) : super(bus, service, storage);
}

@Injectable()
class StageQueries extends Queries {
}

