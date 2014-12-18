import 'dart:js';

import 'package:codemirror/codemirror.dart';

import '../endpoints/endpoints.dart';
import 'codemirror_input.dart';

bool completionInstalled = false;

void installCompletion() {
  if (!completionInstalled) {
    installHints();
    completionInstalled = true;
  }
}

void installHints() {
  CodeMirror.registerHelper("hint", "sparql", sparqlCompletion);

}

JsObject sparqlCompletion(JsObject jseditor, JsObject options) {
  GradeMirror editor = new GradeMirror.fromJsObject(jseditor);

  CodemirrorInput cmInput = editor.getOption("CodemirrorInput");
  Iterable<EditableEndpoint> endpoints = cmInput.endpoints;
  if (endpoints == null) return null;

  Set<String> suggestions = new Set<String>();
  endpoints.map((EditableEndpoint e) => e.model.graphs).expand((List<Graph> graphs) => graphs).forEach((Graph g) => suggestions.add(g.uri));


  Position position = editor.getCursor();

  return new JsObject.jsify({
    "list": suggestions.toList(),
    "from": position.toProxy(),
    "to": position.toProxy()
  });
}

//tmp solution waiting for CodeMirror constructor with JsObject
class GradeMirror extends ProxyHolder {

  GradeMirror.fromJsObject(JsObject object) : super(object);

  Position getCursor([String start]) => new Position.fromProxy(start == null ? call('getCursor') : callArg('getCursor', start));
  dynamic getOption(String option) => callArg('getOption', option);

}
