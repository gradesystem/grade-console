import 'package:polymer/polymer.dart';
import 'package:codemirror/codemirror.dart';

import '../endpoints/endpoints.dart';
import 'codemirror_completion.dart';

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

  @published
  bool autoheight = false;
  
  @published
  Iterable<EditableEndpoint> endpoints;

  CodeMirror editor;

  CodemirrorInput.created() : super.created() {
    onPropertyChange(this, #active, refresh);
    onPropertyChange(this, #mode, updateMode);

    installCompletion();
  }

  void refresh() {
    editor.refresh();
  }

  void readonly() {

  }

  void updateMode() {
    editor.setMode(mode);
  }

  void ready() {

    Map options = {
      'mode': mode,
      'extraKeys': {'Ctrl-Space': 'autocomplete'},
      'CodemirrorInput':this
    };

    if (autoheight) options["viewportMargin"] = double.INFINITY;

    editor = new CodeMirror.fromElement($['codemirror'], options: options);
    editor.setLineNumbers(true);

    onPropertyChange(this, #value, () {
      if (value != null && value != editor.getDoc().getValue()) {
        editor.getDoc().setValue(value);
        editor.refresh();
      }
    });

    editor.onChange.listen((_) {
      String cmValue = editor.getDoc().getValue();
      value = (cmValue == null || cmValue.isEmpty) ? null : cmValue;
    });

    onPropertyChange(this, #disabled, setReadOnly);

  }

  void setReadOnly() {
    editor.setOption("readOnly", disabled);
    editor.setOption("cursorBlinkRate", disabled ? 0 : 530);
  }

  void paste(String text) {
    String selection = editor.getDoc().getSelection();
    if (selection != null && selection.isNotEmpty) {
      //replace selection
      editor.getDoc().callArgs('replaceSelection', [text]);
    } else {
      //insert text
      Position cursorPosition = editor.getDoc().getCursor();
      editor.getDoc().callArgs('replaceRange', [text, cursorPosition.toProxy(), cursorPosition.toProxy()]);
    }
  }

}

