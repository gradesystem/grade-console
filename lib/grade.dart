library grade;

import 'package:event_bus/event_bus.dart';

import 'package:di/di.dart';

import 'package:polymer/polymer.dart';

import 'package:logging/logging.dart';

import 'dart:html';

import 'common.dart';
import 'home.dart' as home;
import 'repo.dart' as repo;
import 'staging.dart' as staging;

part 'grade/grade_console.dart';

//lib-level logger
final Logger log = new Logger('grade');


init() {
  
    _initLogging();

    log.info("initialising modules...");
        
    log.fine("initialising modules...");
    
    _initModules();

    log.fine("initialising polymers...");
    
    initPolymer();
    
    log.finer("initialised.");
}



_initLogging() {
  

   Logger.root.level = Level.ALL;
   
   Logger.root.onRecord.listen((LogRecord rec) {
   
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

  //add app-level modules
  Module module = new Module()
                      ..bind(EventBus, toValue: new EventBus());
  
  Dependencies.add(module);
  
  Dependencies.configure(); 
}
