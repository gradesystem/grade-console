part of prod;

@CustomTag("prod-page") 
class ProdPage extends Polybase {
  
  ProdPage.created() : super.createWith(ProdPageModel);
  
  ProdPageModel get prodModel => model as ProdPageModel;
  
  QuerySubPageModel get queries => prodModel.queriesModel;
  EndpointSubPageModel get endpoints => prodModel.endpointsModel;
  
}
