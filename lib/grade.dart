library grade;

import 'package:event_bus/event_bus.dart';

import 'package:di/di.dart';

import 'package:polymer/polymer.dart';

import 'package:core_elements/core_pages.dart';

import 'package:logging/logging.dart';
import 'package:logging/logging.dart' as logging;

import 'dart:html';
import 'dart:async';

import 'common.dart';
import 'home.dart' as home;
import 'prod.dart' as prod;
import 'deck.dart' as deck;
import 'stage.dart' as staging;
import 'tasks.dart' as tasks;

import 'common/endpoints/endpoints.dart';
import 'common/components/core_resizable.dart';

part 'grade/grade_console.dart';

//lib-level logger
final Logger log = new Logger('grade');

Element loader = querySelector("#loader");

EventBus bus = new EventBus();

init() {

  _initLogging();

  log.fine("initialising polymer...");

  initPolymer().run(() {

    Polymer.onReady.then((_) {
      log.fine("polymer ready");
      _initModules();
      bus.fire(const PolymerReady());
      _hideLoader();

    });
  });

  bus.on(ApplicationInitialized).listen((_) {
    log.info("areas ready, firing application ready...");
    bus.fire(const ApplicationReady());
  });
}

_hideLoader() {
  loader.style.display = "none";
}

_initLogging() {

  logging.hierarchicalLoggingEnabled = true;

  log.level = Level.ALL;

  log.onRecord.listen((LogRecord rec) {

    //log format
    print('${rec.level.name}: ${rec.time}, ${rec.loggerName}: ${rec.message}');

    //error log format
    if (rec.error != null) print('error => ${rec.error} \ntrace => ${rec.stackTrace}');
  });
}

_initModules() {

  log.info("initialising modules...");

  home.init();
  prod.init();
  deck.init();
  staging.init();
  tasks.init();

  GradeEnpoints gradeEnpoints = new GradeEnpoints();

  //add app-level modules
  Module module = new Module()
      ..bind(EventBus, toValue: bus)
      ..bind(GradeEnpoints, toValue: gradeEnpoints);

  Dependencies.add(module);

  Dependencies.configure();

  gradeEnpoints.addList(Dependencies.injector.get(EndpointSubPageModel, prod.ProdAnnotation), "Data");
  gradeEnpoints.addList(Dependencies.injector.get(EndpointSubPageModel, staging.StageAnnotation), "Sources");

  log.finer("modules ready");
}
