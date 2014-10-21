part of prod;

@Injectable()
class ProdService extends DatasetService {
  ProdService() : super("prod");
}

@Injectable()
class ProdQueriesService extends QueryService {
  ProdQueriesService() : super("prod");
}
