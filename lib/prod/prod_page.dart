part of prod;

@CustomTag("prod-page") 
class ProdPage extends Polybase {
  
  ProdPage.created() : super.createWith(ProdPageModel);
  
  ProdPageModel get prodModel => model as ProdPageModel;
  
  ProdDatasetsModel get datasets => prodModel.datasetsModel;
  ProdQueriesModel get queries => prodModel.queriesModel;
}

@Injectable()
class ProdPageModel {
  
  ProdDatasetsModel datasetsModel;
  ProdQueriesModel queriesModel;
  
  
  ProdPageModel(this.datasetsModel, this.queriesModel);
}

@Injectable()
class ProdDatasetsModel extends SubPageModel<Dataset> {
  ProdDatasetsModel(EventBus bus, ProdService service, ProdDatasets storage) : super(bus, service, storage);
}

@Injectable()
class ProdDatasets extends Datasets {
}

@Injectable()
class ProdQueriesModel extends SubPageModel<Query> {
  ProdQueriesModel(EventBus bus, ProdQueriesService service, ProdQueries storage) : super(bus, service, storage);
}

@Injectable()
class ProdQueries extends Queries {
}

