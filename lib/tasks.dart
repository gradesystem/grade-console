library tasks;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';
import 'package:core_elements/core_list_dart.dart';

import 'common.dart';
import 'common/lists/lists.dart';
import 'common/pages/pages.dart';
import 'common/queries/queries.dart';

part 'tasks/tasks_page.dart';
part 'tasks/task_details.dart';
part 'tasks/tasks_service.dart';
part 'tasks/tasks_model.dart';
part 'tasks/tasks_panel.dart';
part 'tasks/task_list.dart';

final Logger log = new Logger('grade.tasks');

init() {
  
  var module = new Module()
          ..bind(TasksPageModel)          
          
          ..bind(TasksModel)
          ..bind(Tasks)
          
          ..bind(TasksQueriesModel)
          ..bind(TasksQueries)
          
          ..bind(TasksService)
          ..bind(TasksQueriesService);
  
  Dependencies.add(module);
}
