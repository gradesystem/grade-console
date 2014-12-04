part of stage;


@Injectable()
class StagePageModel {
  
  StageQueriesModel queriesModel;
  EndpointSubPageModel endpointsModel;
  
  StagePageModel(this.queriesModel, @StageAnnotation() this.endpointsModel);

}


@Injectable()
class StageQueriesModel extends QuerySubPageModel {
  StageQueriesModel(EventBus bus, StageQueriesService service, StageQueries storage) : super(bus, service, storage);
}

@Injectable()
class StageQueries extends Queries {
}
