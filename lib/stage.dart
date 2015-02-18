library stage;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/datasets/datasets.dart';
import 'common/queries/queries.dart';
import 'common/endpoints/endpoints.dart';
import 'common/components/core_resizable.dart';

part 'stage/stage_page.dart';

final Logger log = new Logger('grade.stage');

class StageAnnotation {
  const StageAnnotation();
}

final String _service_path = "stage";

init() {
  
  String page = "stage";
  
  String base_url = window.location.origin;
  
  Dependencies.bind(page, StageAnnotation);
  
  var module = new Module()
  
          ..bind(PageEventBus, toFactory: (bus) => new PageEventBus(page, bus), withAnnotation: const StageAnnotation(), inject: [EventBus])

          ..bind(Datasets, toValue: new Datasets(), withAnnotation: const StageAnnotation())
          ..bind(DatasetsPageModel, toFactory: (bus, datasets) => new DatasetsPageModel(bus, new DatasetService(_service_path), datasets), withAnnotation: const StageAnnotation(), inject: [new Key(PageEventBus, const StageAnnotation()), new Key(Datasets, const StageAnnotation())])
          
          ..bind(QuerySubPageModel, toFactory: (bus) => new QuerySubPageModel(bus, new QueryService(base_url, _service_path), new Queries()), withAnnotation: const StageAnnotation(), inject: [new Key(PageEventBus, const StageAnnotation())])
          
          ..bind(Endpoints, toValue: new Endpoints(), withAnnotation: const StageAnnotation())
          ..bind(EndpointSubPageModel, toFactory: (bus, endpoints) => new EndpointSubPageModel(bus, new EndpointsService(_service_path), endpoints), withAnnotation: const StageAnnotation(), inject: [new Key(PageEventBus, const StageAnnotation()), new Key(Endpoints, const StageAnnotation())]);
 
  
  Dependencies.add(module);
}
