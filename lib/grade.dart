library grade;

import 'package:event_bus/event_bus.dart';

import 'package:di/di.dart';

import 'package:polymer/polymer.dart';

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

part 'grade/grade_console.dart';

//lib-level logger
final Logger log = new Logger('grade');

Element loader = querySelector("#loader");

EventBus bus;

init() {
  
    _initLogging();

    log.info("initialising modules...");
    
    _initModules();

    log.fine("initialising polymers...");
    
    DateTime start = new DateTime.now();
    
    bus.on(HomeRendered).listen((_) {
      
      _hideLoader();
      
      new Timer(new Duration(seconds: 1), () {
      
      start = new DateTime.now();
      bus.fire(const ApplicationRenderingReady());
      log.fine("areas ready, elapsed ${new DateTime.now().difference(start)}");
   
    });
      });
    
    bus.on(AreasReady).listen((_) {
      start = new DateTime.now();
      bus.fire(const ApplicationReady());
      log.fine("application ready, elapsed ${new DateTime.now().difference(start)}");
    });
    
    initPolymer().run(() {

        Polymer.onReady.then((_) {
          log.fine("polymers ready, elapsed ${new DateTime.now().difference(start)}");

          
        });
      });
    
    log.finer("initialised.");
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
     if (rec.error!=null)
        print('error => ${rec.error} \ntrace => ${rec.stackTrace}');
    });
}

_initModules() {
  
  home.init();
  prod.init();
  deck.init();
  staging.init();
  tasks.init();
  
  bus = new EventBus();
  GradeEnpoints gradeEnpoints = new GradeEnpoints();

  //add app-level modules
  Module module = new Module()
                      ..bind(EventBus, toValue: bus)
                      ..bind(GradeEnpoints, toValue: gradeEnpoints);
  
  Dependencies.add(module);
  
  Dependencies.configure(); 
  
  gradeEnpoints.addList(Dependencies.injector.get(EndpointSubPageModel, prod.ProdAnnotation), "Data");
  gradeEnpoints.addList(Dependencies.injector.get(EndpointSubPageModel, staging.StageAnnotation), "Sources");
}
