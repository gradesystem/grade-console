
library repo;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/graphs/graphs.dart';

part 'repo/repo_page.dart';
part 'repo/repo_service.dart';

final Logger log = new Logger('grade.repo');

init() {
  
  var module = new Module()
          ..bind(RepoPageModel)
          ..bind(RepoGraphs)
          ..bind(RepoService);
  
  Dependencies.add(module);
  Dependencies.bind("RepoGraphs", RepoGraphs);
}
