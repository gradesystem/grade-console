part of stage;

@Injectable()
class StageService extends DatasetService {
  StageService() : super("prod");
}

@Injectable()
class StageQueriesService extends QueryService {
  StageQueriesService() : super("prod");
}


@Injectable()
class StageEndpointsService extends EndpointsService {
  StageEndpointsService() : super("prod");
}
