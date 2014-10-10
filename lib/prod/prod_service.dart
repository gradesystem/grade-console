part of prod;

@Injectable()
class ProdService extends DatasetService {
  ProdService(HttpService http) : super(http, "prod");
}
