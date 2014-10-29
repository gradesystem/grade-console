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


  CodemirrorInput.created() : super.created();

  
  void ready() {
    
    Map options = {
      'mode':  mode
    };

    CodeMirror editor = new CodeMirror.fromElement(
        $['codemirror'], options: options);

    onPropertyChange(this, #value, (){
      print('onPropertyChange');
      editor.setOption("value", value);
    });
    
    editor.onChange.listen((_){
      print('editor.onChange.listen');
      value = editor.getDoc().getValue();
    });
    
   
   /* changes.listen((records) {
        for (var record in records) {
          if (record is PropertyChangeRecord &&
              (record as PropertyChangeRecord).name ==  #value) {
            PropertyChangeRecord changeRecord = record as PropertyChangeRecord;
            if (changeRecord.newValue!=null && changeRecord.oldValue!=LOCAL_UPDATE) editor.setOption("value", value);
            break;
          }
        }
      });
    
    editor.onChange.listen((_){
         print('changes');
         local_value = editor.getDoc().getValue();
         print('value: $value');
         notifyPropertyChange(#value, LOCAL_UPDATE, editor.getDoc().getValue());
       });*/
  }

  
}
