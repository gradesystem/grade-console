part of prod;

@CustomTag("prod-page") 
class ProdPage extends Polybase {
  
  ProdPage.created() : super.createWith(ProdPageModel);
  
  ProdPageModel get prodModel => model as ProdPageModel;
  
  ProdDatasetsModel get datasets => prodModel.datasetsModel;
  ProdQueriesModel get queries => prodModel.queriesModel;
  ProdEndpointsModel get endpoints => prodModel.endpointsModel;
  
}
