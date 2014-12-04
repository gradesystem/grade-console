library stage;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/datasets/datasets.dart';
import 'common/queries/queries.dart';
import 'common/endpoints/endpoints.dart';

part 'stage/stage_page.dart';
part 'stage/stage_service.dart';
part 'stage/stage_model.dart';

final Logger log = new Logger('grade.stage');


class StageAnnotation {
  const StageAnnotation();
}

init() {
  
  Dependencies.bind("stage", StageAnnotation);
  
  var module = new Module()
          ..bind(StagePageModel) 

          ..bind(Datasets, toValue: new Datasets(), withAnnotation: const StageAnnotation())
          ..bind(DatasetsPageModel, toFactory: (bus, datasets) => new DatasetsPageModel(bus, new DatasetService(_service_path), datasets), withAnnotation: const StageAnnotation(), inject: [EventBus, new Key(Datasets,StageAnnotation)])
          
          ..bind(StageQueriesService)
          ..bind(StageQueriesModel)
          ..bind(StageQueries)


          ..bind(EndpointSubPageModel, toFactory: (bus) => new EndpointSubPageModel(bus, new EndpointsService(_service_path), new Endpoints()), withAnnotation: const StageAnnotation(), inject: [EventBus]);
          ;

  
  Dependencies.add(module);
}
