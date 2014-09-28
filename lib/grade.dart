library grade;

import 'package:event_bus/event_bus.dart';

import 'package:di/di.dart';
import 'package:di/annotations.dart';

import 'package:polymer/polymer.dart';

import 'package:logging/logging.dart';

import 'dart:html';

import 'common.dart';
import 'staging.dart' as staging;
import 'home.dart' as home;

part 'grade/grade_console.dart';

final Logger _log = new Logger('grade');



init() {
  
   Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) {
      print('${rec.level.name}: ${rec.time}, ${rec.loggerName}: ${rec.message}');
      if (rec.error!=null)
        print('error => ${rec.error} \ntrace => ${rec.stackTrace}');
    });

    _log.info("initialising...");
    
    staging.init();
    home.init();

    Module module = new Module()
                        ..bind(GradeConsoleModel)
                        ..bind(EventBus, toValue: new EventBus());

    
    Dependencies.add(module);
      
    Dependencies.configure(); 
    
    initPolymer();

}
