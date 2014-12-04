part of prod;


@Injectable()
class ProdPageModel {
  
  ProdDatasetsModel datasetsModel;
  ProdQueriesModel queriesModel;
  
  EndpointSubPageModel endpointsModel;
  
  ProdPageModel(this.datasetsModel, this.queriesModel, @ProdAnnotation() this.endpointsModel);
}

@Injectable()
class ProdDatasetsModel extends SubPageModel<Dataset> {
  ProdDatasetsModel(EventBus bus, ProdDatasetService service, ProdDatasets storage) : super(bus, service, storage);
}

@Injectable()
class ProdDatasets extends Datasets {
}

@Injectable()
class ProdQueriesModel extends QuerySubPageModel {
  ProdQueriesModel(EventBus bus, ProdQueriesService service, ProdQueries storage) : super(bus, service, storage);
}

@Injectable()
class ProdQueries extends Queries {
}