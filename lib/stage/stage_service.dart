part of stage;

@Injectable()
class StageService extends DatasetService {
  StageService(HttpService http) : super(http, "prod");
}
