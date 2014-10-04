
library repo;

import 'dart:html';
import 'dart:async';
import 'dart:mirrors';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';

part 'repo/repo_page.dart';
part 'repo/graph_details.dart';
part 'repo/graphs_list.dart';
part 'repo/graph_item.dart';
part 'repo/repo_model.dart';
part 'repo/repo_service.dart';

final Logger log = new Logger('grade.repo');

init() {
  
  var module = new Module()
          ..bind(RepoPageModel)
          ..bind(Graphs)
          ..bind(RepoService);
  
  Dependencies.add(module);
}
