part of prod;

final String _service_path = "prod";

@Injectable()
class ProdDatasetService extends DatasetService {
  ProdDatasetService() : super(_service_path);
}

@Injectable()
class ProdQueriesService extends QueryService {
  ProdQueriesService() : super(_service_path);
}

