part of stage;

final String _path = "stage";

@Injectable()
class StageService extends DatasetService {
  StageService() : super(_path);
}

@Injectable()
class StageQueriesService extends QueryService {
  StageQueriesService() : super(_path);
}

@Injectable()
class StageEndpointsService extends EndpointsService {
  StageEndpointsService() : super(_path);
}
