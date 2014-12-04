part of stage;

@CustomTag("stage-page") 
class StagePage extends Polybase {
  
  
  StagePage.created() : super.createWith(StagePageModel);

  
  StagePageModel get stageModel => model as StagePageModel;
  
  QuerySubPageModel get queries => stageModel.queriesModel;
  EndpointSubPageModel get endpoints => stageModel.endpointsModel;
}
