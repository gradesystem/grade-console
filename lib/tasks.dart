library tasks;

import 'dart:collection';
import 'dart:async';
import 'dart:convert' show JSON;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';
import 'package:core_elements/core_list_dart.dart';
import 'package:core_elements/core_collapse.dart';

import 'common.dart';
import 'common/lists/lists.dart';
import 'common/queries/queries.dart';
import 'common/endpoints/endpoints.dart';
import 'common/editables/editables.dart';

part 'tasks/tasks_page.dart';
part 'tasks/task_details.dart';
part 'tasks/tasks_service.dart';
part 'tasks/tasks_model.dart';
part 'tasks/tasks_panel.dart';
part 'tasks/task_list.dart';
part 'tasks/task_details_summary.dart';
part 'tasks/task_playground.dart';
part 'tasks/task_execution.dart';
part 'tasks/running_task_panel.dart';

final Logger log = new Logger('grade.tasks');

class TasksAnnotation {
  const TasksAnnotation();
}

init() {
  
  Dependencies.bind("tasks", TasksAnnotation);
  
  var module = new Module()
          
          ..bind(TasksService)
          ..bind(TaskExecutionsService)
          ..bind(TasksModel)
          ..bind(Tasks)
          
          ..bind(QuerySubPageModel, toFactory: (bus) => new QuerySubPageModel(bus, new QueryService(_service_path), new Queries()), withAnnotation: const TasksAnnotation(), inject: [EventBus])

          ..bind(Endpoints, toValue: new Endpoints(), withAnnotation: const TasksAnnotation())
          ..bind(EndpointSubPageModel, toFactory: (bus, endpoints) => new EndpointSubPageModel(bus, new EndpointsService(_service_path), endpoints), withAnnotation: const TasksAnnotation(), inject: [EventBus, new Key(Endpoints, const TasksAnnotation())]);
  
  Dependencies.add(module);
}
