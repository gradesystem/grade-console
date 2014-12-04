part of stage;


@Injectable()
class StagePageModel {
  
  QuerySubPageModel queriesModel;
  EndpointSubPageModel endpointsModel;
  
  StagePageModel( @StageAnnotation() this.queriesModel, @StageAnnotation() this.endpointsModel);

}
