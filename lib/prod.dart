library prod;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/datasets/datasets.dart';
import 'common/queries/queries.dart';
import 'common/pages/pages.dart';
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
          ..bind(ProdPageModel)
          
          ..bind(ProdDatasetsModel)
          ..bind(ProdDatasets)
          ..bind(ProdDatasetService)
          
          ..bind(ProdQueriesModel)
          ..bind(ProdQueries)
          ..bind(ProdQueriesService)

          ..bind(EndpointSubPageModel, toImplementation: ProdEndpointsModel, withAnnotation: const ProdAnnotation());
  
  
  Dependencies.add(module);
}
