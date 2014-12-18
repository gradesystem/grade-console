import 'dart:js';

import 'package:polymer/polymer.dart';
import 'package:codemirror/codemirror.dart';

import '../endpoints/endpoints.dart';

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

  static bool helperInstalled = false;

  CodemirrorInput.created() : super.created() {
    onPropertyChange(this, #active, refresh);
    onPropertyChange(this, #mode, updateMode);

    if (!helperInstalled) installHelper();
  }

  void installHelper() {
    CodeMirror.registerHelper("hint", "sparql", (jseditor, JsObject options) {

      GradeMirror editor = new GradeMirror.fromJsObject(jseditor);

      CodemirrorInput cmInput = editor.getOption("CodemirrorInput");
      Iterable<EditableEndpoint> endpoints = cmInput.endpoints;
      if (endpoints == null) return null;
      
      Set<String> suggestions = new Set<String>();
      endpoints
      .map((EditableEndpoint e)=>e.model.graphs)
      .expand((List<Graph> graphs)=>graphs)
      .forEach((Graph g)=>suggestions.add(g.uri));
      

      Position position = editor.getCursor();

      return new JsObject.jsify({
        "list": suggestions.toList(),
        "from": position.toProxy(),
        "to": position.toProxy()
      });
    });

    helperInstalled = true;

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
    Position cursorPosition = editor.getDoc().getCursor();
    editor.getDoc().callArgs('replaceRange', [text, cursorPosition.toProxy(), cursorPosition.toProxy()]);
  }

}

class GradeMirror extends ProxyHolder {

  GradeMirror.fromJsObject(JsObject object) : super(object);

  Position getCursor([String start]) => new Position.fromProxy(start == null ? call('getCursor') : callArg('getCursor', start));
  dynamic getOption(String option) => callArg('getOption', option);

}
