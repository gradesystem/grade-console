
library tasks;

import 'dart:html';
import 'dart:async';
import 'dart:mirrors';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';

part 'tasks/tasks_page.dart';

final Logger log = new Logger('grade.tasks');

init() {
  
  var module = new Module()
          ..bind(TasksPageModel);
  
  Dependencies.add(module);
}
