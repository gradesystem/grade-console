part of prod;


@Injectable()
class ProdPageModel {
  
  QuerySubPageModel queriesModel;
  
  EndpointSubPageModel endpointsModel;
  
  ProdPageModel(@ProdAnnotation() this.queriesModel, @ProdAnnotation() this.endpointsModel);
}