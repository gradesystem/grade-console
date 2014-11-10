part of stage;


@Injectable()
class StagePageModel {
  
  StageDatasetsModel datasetsModel;
  StageQueriesModel queriesModel;
  StageEndpointsModel endpointsModel;
  
  
  StagePageModel(this.datasetsModel, this.queriesModel,this.endpointsModel);
}

@Injectable()
class StageDatasetsModel extends SubPageModel<Dataset> {
   StageDatasetsModel(EventBus bus, StageService service, StageDatasets storage) : super(bus, service, storage);
}

@Injectable()
class StageDatasets extends Datasets {
}

@Injectable()
class StageQueriesModel extends QuerySubPageModel {
  StageQueriesModel(EventBus bus, StageQueriesService service, StageQueries storage) : super(bus, service, storage);
}

@Injectable()
class StageQueries extends Queries {
}

@Injectable()
class StageEndpointsModel extends EndpointSubPageModel {
  StageEndpointsModel(EventBus bus, StageEndpointsService service, StageEndpoints storage) : super(bus, service, storage);
}

@Injectable()
class StageEndpoints extends Endpoints {
}