library navigator;

import 'package:polymer/polymer.dart';
import 'dart:html';

import 'package:grade_console/common/queries/queries.dart';


void main() {
  
   initPolymer().run(() {});
}



@CustomTag("grade-nav")
class Navigator extends PolymerElement {
  
  @observable
  int resultTab = 0;
  
  @published
  Result result;
  
  @published
  String uri;
  
  String endpoint;
  
  Navigator.created() : super.created() {
    
    Location loc = document.window.location; 
    
    Uri uri = Uri.parse(loc.href);

    this.uri = uri.queryParameters["uri"];
    
    this.endpoint = uri.queryParameters["endpoint"];
  }
  
 
     
}
