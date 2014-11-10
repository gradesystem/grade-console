part of prod;

final String path = "prod";

@Injectable()
class ProdDatasetService extends DatasetService {
  ProdDatasetService() : super(path);
}

@Injectable()
class ProdQueriesService extends QueryService {
  ProdQueriesService() : super(path);
}

@Injectable()
class ProdEndpointsService extends EndpointsService {
  ProdEndpointsService() : super(path);
}
