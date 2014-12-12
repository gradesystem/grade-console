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
      if (value!=null && value!=editor.getDoc().getValue()) {
        editor.getDoc().setValue(value);
        editor.refresh();
      }
    });
    
    editor.onChange.listen((_){
      String cmValue = editor.getDoc().getValue();
      value = (cmValue==null || cmValue.isEmpty)?null:cmValue;
    });
    
    onPropertyChange(this, #disabled, (){
      editor.setOption("readOnly", disabled?"nocursor":false);
    });

  }
  
  void paste(String text) {
    Position cursorPosition = editor.getDoc().getCursor();
    editor.getDoc().callArgs('replaceRange', [text, cursorPosition.toProxy(), cursorPosition.toProxy()]);
  }
  
}