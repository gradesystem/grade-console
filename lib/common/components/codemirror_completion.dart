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

Map<String, String> PREFIXES = {
  "rdfs": "rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
  "rdf": "rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
  "dc": "dc: <http://purl.org/dc/elements/1.1/>",
  "geo": "geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>",
  "owl": "owl: <http://www.w3.org/2002/07/owl#>",
  "dct": "dct: <http://purl.org/dc/terms/>",
  "dwc": "dwc: <http://rs.tdwg.org/dwc/terms/>",
  "skos": "skos: <http://www.w3.org/2004/02/skos/core#>"
};

List<String> SPARQL_KEYWORDS = ["base", "prefix", "select", "distinct", "reduced", "construct", "describe", "ask", "from", "named", "where", "order", "limit", "offset", "filter", "optional", "graph", "by", "asc", "desc", "as", "having", "undef", "values", "group", "minus", "in", "not", "service", "silent", "using", "insert", "delete", "union", "true", "false", "with", "data", "copy", "to", "move", "add", "create", "drop", "clear", "load"];

JsObject sparqlCompletion(JsObject jseditor, JsObject options) {
  CodeMirror editor = new CodeMirror.fromJsObject(jseditor);

  CodemirrorInput cmInput = editor.getOption("CodemirrorInput");
  Iterable<EditableEndpoint> endpoints = cmInput.endpoints;
  if (endpoints == null) return null;

  Position cursorPosition = editor.getCursor();

  String line = editor.getLine(cursorPosition.line);
  //print('line >$line<');
  String subline = line.substring(0, cursorPosition.ch);
  //print('subline >$subline<');

  int lastSpaceIndex = subline.lastIndexOf(new RegExp(r'\s'));
  //print('lastSpaceIndex $lastSpaceIndex');

  String currWord = subline;
  if (lastSpaceIndex >= 0) currWord = subline.substring(lastSpaceIndex + 1, subline.length);
  //print('currWord >$currWord<');

  Set<JsObject> suggestions = new Set<JsObject>();

  if (currWord.isNotEmpty) fillMatchingKeywords(suggestions, currWord); else {

    lastSpaceIndex = lastSpaceIndex >= 0 ? lastSpaceIndex : 0;

    subline = subline.substring(0, lastSpaceIndex);
    //print('subline >$subline<');

    int prevSpaceIndex = subline.lastIndexOf(new RegExp(r'\s'));
    //print('prevSpaceIndex $prevSpaceIndex');

    String prevWord = subline.substring((prevSpaceIndex >= 0) ? prevSpaceIndex + 1 : 0);
    //print('prevWord >$prevWord<');

    switch (prevWord.toLowerCase()) {
      case "graph":
        fillGraphs(suggestions, endpoints);
        break;
      case "service":
        fillServices(suggestions, endpoints);
        break;
      case "prefix":
        fillPrefixes(suggestions);
        break;
      default:
        fillKeywords(suggestions);
        break;
    }
  }


  return new JsObject.jsify({
    "list": suggestions.toList(),
    "from": cursorPosition.toProxy(),
    "to": cursorPosition.toProxy()
  });
}

void fillGraphs(Set<JsObject> suggestions, Iterable<EditableEndpoint> endpoints) {
  endpoints.map((EditableEndpoint e) => e.model.graphs).expand((List<Graph> graphs) => graphs).map((Graph g) => new JsObject.jsify({
    "text": "<${g.uri}>",
    "displayText": "${g.label} - ${g.uri}"
  })).forEach((JsObject o) => suggestions.add(o));
}

void fillServices(Set<JsObject> suggestions, Iterable<EditableEndpoint> endpoints) {
  endpoints.map((EditableEndpoint e) => new JsObject.jsify({
    "text": "<${e.model.uri}>",
    "displayText": e.model.name
  })).forEach((JsObject o) => suggestions.add(o));
}

void fillMatchingKeywords(Set<JsObject> suggestions, String word) {
  SPARQL_KEYWORDS.where((String k) => k.startsWith(word)).map((String u) => new JsObject.jsify({
    "text": u.substring(word.length),
    "displayText": u
  })).forEach((JsObject o) => suggestions.add(o));
}

void fillKeywords(Set<JsObject> suggestions) {
  SPARQL_KEYWORDS.map((String u) => new JsObject.jsify({
    "text": u,
    "displayText": u
  })).forEach((JsObject o) => suggestions.add(o));
}

void fillPrefixes(Set<JsObject> suggestions) {
  PREFIXES.keys.map((String key) => new JsObject.jsify({
    "text": PREFIXES[key],
    "displayText": key
  })).forEach((JsObject o) => suggestions.add(o));
}