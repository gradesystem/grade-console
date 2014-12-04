library stage;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/datasets/datasets.dart';
import 'common/queries/queries.dart';
import 'common/endpoints/endpoints.dart';

part 'stage/stage_page.dart';

final Logger log = new Logger('grade.stage');

class StageAnnotation {
  const StageAnnotation();
}

final String _service_path = "stage";

init() {
  
  Dependencies.bind("stage", StageAnnotation);
  
  var module = new Module()

          ..bind(Datasets, toValue: new Datasets(), withAnnotation: const StageAnnotation())
          ..bind(DatasetsPageModel, toFactory: (bus, datasets) => new DatasetsPageModel(bus, new DatasetService(_service_path), datasets), withAnnotation: const StageAnnotation(), inject: [EventBus, new Key(Datasets,StageAnnotation)])
          
          ..bind(QuerySubPageModel, toFactory: (bus) => new QuerySubPageModel(bus, new QueryService(_service_path), new Queries()), withAnnotation: const StageAnnotation(), inject: [EventBus])
          
          ..bind(Endpoints, toValue: new Endpoints(), withAnnotation: const StageAnnotation())
          ..bind(EndpointSubPageModel, toFactory: (bus, endpoints) => new EndpointSubPageModel(bus, new EndpointsService(_service_path), endpoints), withAnnotation: const StageAnnotation(), inject: [EventBus, new Key(Endpoints, const StageAnnotation())]);
 
  
  Dependencies.add(module);
}
