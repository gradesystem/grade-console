import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:codemirror/codemirror.dart';

@CustomTag("codemirror-input")
class CodemirrorInput extends PolymerElement {
  
  @published
  String mode;
  
  @published
  String value;
  
  @published
  bool active;
  
  @published
  bool disabled;

  CodeMirror editor;

  
  CodemirrorInput.created() : super.created() {
    onPropertyChange(this, #active, refresh);        
  }

  void refresh() {
    print('refreshing codemirror');
    editor.refresh();
  }
  
  void readonly() {
    
  }
  
  void ready() {
    
    Map options = {
      'mode':  mode
    };

    editor = new CodeMirror.fromElement(
        $['codemirror'], options: options);
    editor.setLineNumbers(true);

    onPropertyChange(this, #value, (){
      //print('onPropertyChange');
      if (value!=editor.getDoc().getValue()) {
        //print('setting value');
        editor.getDoc().setValue(value);
        editor.refresh();
      }
      //else print('skipping update');
    });
    
    editor.onChange.listen((_){
      //print('editor.onChange.listen');
      value = editor.getDoc().getValue();
    });
    
    onPropertyChange(this, #disabled, (){
//      print('readOnly $disabled');
      editor.setOption("readOnly", disabled?"nocursor":false);
    });

  }
  
  /**
   * How to listen to attributes changes, for parent refresh notification:
   void attributeChanged(name, oldValue, newValue) {
    super.attributeChanged(name, oldValue, newValue);
    if (name == "active") isactive =  attributes.containsKey('active');
  }
   */

  
}
