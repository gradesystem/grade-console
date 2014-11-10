library stage;

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

part 'stage/stage_page.dart';
part 'stage/stage_service.dart';
part 'stage/stage_model.dart';

final Logger log = new Logger('grade.stage');

init() {
  
  var module = new Module()
          ..bind(StagePageModel)          
          
          ..bind(StageDatasetsModel)
          ..bind(StageDatasets)
          
          ..bind(StageQueriesModel)
          ..bind(StageQueries)
          
          ..bind(StageService)
          ..bind(StageQueriesService)
          
          
           ..bind(StageEndpointsModel)
           ..bind(StageEndpoints)
           ..bind(StageEndpointsService);
  
  Dependencies.add(module);
}
