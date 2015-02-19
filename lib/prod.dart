library prod;

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

part 'prod/prod_page.dart';

final Logger log = new Logger('grade.prod');

class ProdAnnotation {
  const ProdAnnotation();
}

final String _service_path = "prod";

init() {
  
  String page = "prod";
  
  Dependencies.bind("prod", ProdAnnotation);

  String base_url = window.location.origin;
  
  Endpoints endpoints = new Endpoints();
  
  var module = new Module()
         
          ..bind(PageEventBus, toFactory: (bus) => new PageEventBus(page, bus), withAnnotation: const ProdAnnotation(), inject: [EventBus])
         
          ..bind(Datasets, toValue: new Datasets(), withAnnotation: const ProdAnnotation())
          ..bind(DatasetsPageModel, toFactory: (bus, datasets) => new DatasetsPageModel(bus, new DatasetService(_service_path), datasets), withAnnotation: const ProdAnnotation(), inject: [new Key(PageEventBus, const ProdAnnotation()), new Key(Datasets, const ProdAnnotation())])

          
          ..bind(QuerySubPageModel, toFactory: (bus) => new QuerySubPageModel(bus, new QueryService(base_url, _service_path), new Queries(), endpoints), withAnnotation: const ProdAnnotation(), inject: [new Key(PageEventBus, const ProdAnnotation())])

          ..bind(Endpoints, toValue: endpoints, withAnnotation: const ProdAnnotation())
          ..bind(EndpointSubPageModel, toFactory: (bus, endpoints) => new EndpointSubPageModel(bus, new EndpointsService(_service_path), endpoints), withAnnotation: const ProdAnnotation(), inject: [new Key(PageEventBus, const ProdAnnotation()), new Key(Endpoints, const ProdAnnotation())]);
    
  
  Dependencies.add(module);
}
