part of stage;

@CustomTag("stage-page") 
class StagePage extends Polybase {
  StagePage.created() : super.createWith(StagePageModel);
}

@Injectable()
class StagePageModel {
}

