part of prod;


@Injectable()
class ProdPageModel {
  
  ProdQueriesModel queriesModel;
  
  EndpointSubPageModel endpointsModel;
  
  ProdPageModel(this.queriesModel, @ProdAnnotation() this.endpointsModel);
}

@Injectable()
class ProdQueriesModel extends QuerySubPageModel {
  ProdQueriesModel(EventBus bus, ProdQueriesService service, ProdQueries storage) : super(bus, service, storage);
}

@Injectable()
class ProdQueries extends Queries {
}