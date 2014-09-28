library staging;

import 'package:event_bus/event_bus.dart';

import 'package:di/di.dart';
import 'package:di/annotations.dart';

import 'package:polymer/polymer.dart';

import 'package:logging/logging.dart';

import 'common.dart';

part 'staging/staging_service.dart';
part 'staging/staging_page.dart';

init() {
  
  var module = new Module()
          ..bind(StagingService)
          ..bind(StagingPageModel);

  Dependencies.add(module);
}