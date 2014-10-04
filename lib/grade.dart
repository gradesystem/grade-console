library grade;

import 'package:event_bus/event_bus.dart';

import 'package:di/di.dart';

import 'package:polymer/polymer.dart';

import 'package:logging/logging.dart';
import 'package:logging/logging.dart' as logging;

import 'dart:html';

import 'common.dart';
import 'home.dart' as home;
import 'repo.dart' as repo;
import 'staging.dart' as staging;

part 'grade/grade_console.dart';

//lib-level logger
final Logger log = new Logger('grade');


EventBus bus;

init() {
  
    _initLogging();

    log.info("initialising modules...");
    
    log.fine("initialising polymers...");
    
    _initModules();

    log.fine("initialising polymers...");
    
    initPolymer().run(() {

        Polymer.onReady.then((_) {
          bus.fire(const ApplicationReady());
        });
      });
    
    log.finer("initialised.");
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
  repo.init();
  staging.init();
  
  bus = new EventBus();

  //add app-level modules
  Module module = new Module()
                      ..bind(EventBus, toValue: bus)
                      ..bind(HttpService);
  
  Dependencies.add(module);
  
  Dependencies.configure(); 
}
