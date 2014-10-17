library prod;

import 'dart:async';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';
import 'common/datasets/datasets.dart';
import 'common/lists/lists.dart';

part 'prod/prod_page.dart';
part 'prod/prod_service.dart';

final Logger log = new Logger('grade.prod');

init() {
  
  var module = new Module()
          ..bind(ProdPageModel)
          ..bind(ProdDatasets)
          ..bind(ProdService);
  
  Dependencies.add(module);
}
