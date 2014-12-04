library prod;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/datasets/datasets.dart';
import 'common/queries/queries.dart';
import 'common/endpoints/endpoints.dart';

part 'prod/prod_page.dart';
part 'prod/prod_service.dart';
part 'prod/prod_model.dart';

final Logger log = new Logger('grade.prod');

class ProdAnnotation {
  const ProdAnnotation();
}

init() {
  
  Dependencies.bind("prod", ProdAnnotation);
  
  var module = new Module()
         
          ..bind(Datasets, toValue: new Datasets(), withAnnotation: const ProdAnnotation())
          ..bind(DatasetsPageModel, toFactory: (bus, datasets) => new DatasetsPageModel(bus, new DatasetService(_service_path), datasets), withAnnotation: const ProdAnnotation(), inject: [EventBus, new Key(Datasets,ProdAnnotation)])

          ..bind(QuerySubPageModel, toFactory: (bus) => new QuerySubPageModel(bus, new QueryService(_service_path), new Queries()), withAnnotation: const ProdAnnotation(), inject: [EventBus])

          ..bind(Endpoints, toValue: new Endpoints(), withAnnotation: const ProdAnnotation())
          ..bind(EndpointSubPageModel, toFactory: (bus, endpoints) => new EndpointSubPageModel(bus, new EndpointsService(_service_path), endpoints), withAnnotation: const ProdAnnotation(), inject: [EventBus, new Key(Endpoints, const ProdAnnotation())]);
    
  
  Dependencies.add(module);
}
