part of stage;


@Injectable()
class StagePageModel {
  
  StageDatasetsModel datasetsModel;
  StageQueriesModel queriesModel;
  
  
  StagePageModel(this.datasetsModel, this.queriesModel);
}

@Injectable()
class StageDatasetsModel extends SubPageModel<Dataset> {
   StageDatasetsModel(EventBus bus, StageService service, StageDatasets storage) : super(bus, service, storage);
}

@Injectable()
class StageDatasets extends Datasets {
}

@Injectable()
class StageQueriesModel extends QuerySubPageModel {
  StageQueriesModel(EventBus bus, StageQueriesService service, StageQueries storage) : super(bus, service, storage);
}

@Injectable()
class StageQueries extends Queries {
}