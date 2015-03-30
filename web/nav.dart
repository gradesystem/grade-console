library navigator;

import 'package:polymer/polymer.dart';
import 'package:logging/logging.dart';

//lib-level logger
final Logger log = new Logger('grade-navigator');

void main() {
  
   log.fine("initialising polymer...");

   initPolymer().run(() {});
}



@CustomTag("grade-nav")
class Navigator extends PolymerElement {
  
  Navigator.created() : super.created() {
    
  }
  
 
     
}
