
library tasks;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/datasets/datasets.dart';

part 'tasks/tasks_page.dart';
part 'tasks/task_details.dart';
part 'tasks/tasks_service.dart';

final Logger log = new Logger('grade.tasks');

init() {
  
  var module = new Module()
          ..bind(TasksPageModel)          
          ..bind(TasksDatasets)
          ..bind(TasksService);
  
  Dependencies.add(module);
}
