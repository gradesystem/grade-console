part of stage;

final String _service_path = "stage";

@Injectable()
class StageService extends DatasetService {
  StageService() : super(_service_path);
}

@Injectable()
class StageQueriesService extends QueryService {
  StageQueriesService() : super(_service_path);
}
