part of prod;

final String _path = "prod";

@Injectable()
class ProdDatasetService extends DatasetService {
  ProdDatasetService() : super(_path);
}

@Injectable()
class ProdQueriesService extends QueryService {
  ProdQueriesService() : super(_path);
}

@Injectable()
class ProdEndpointsService extends EndpointsService {
  ProdEndpointsService() : super(_path);
}
