library staging;

import 'dart:html';
import 'dart:async';
import 'dart:mirrors';

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';
import 'package:di/di.dart';
import 'package:di/annotations.dart';
import 'package:event_bus/event_bus.dart';

import 'common.dart';

part 'staging/staging_page.dart';

final Logger log = new Logger('grade.staging');

init() {
  
  var module = new Module()
          ..bind(StagingPageModel);
  
  Dependencies.add(module);
}
