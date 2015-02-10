import 'package:codemirror/codemirror.dart';
import 'package:codemirror/hints.dart';

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
  Hints.registerHintsHelper("sparql", sparqlCompletion);
}

Map<String, String> PREFIXES = {
  "cls": "cls: <http://www.fao.org/figis/flod/onto/codedentityclassification.owl#>",
  "dc": "dc: <http://purl.org/dc/elements/1.1/>",
  "dct": "dct: <http://purl.org/dc/terms/>",
  "dwc": "dwc: <http://rs.tdwg.org/dwc/terms/>",
  "fn": "fn: <http://www.w3.org/2005/xpath-functions#>",
  "geo": "geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>",
  "int": "int: <http://www.fao.org/figis/flod/onto/intersection.owl#>",
  "owl": "owl: <http://www.w3.org/2002/07/owl#>",
  "rdf": "rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
  "rdfs": "rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
  "skos": "skos: <http://www.w3.org/2004/02/skos/core#>",
  "sov": "sov: <http://www.fao.org/figis/flod/onto/sovereignty.owl#>",
  "xpl": "xpl: <http://www.fao.org/figis/flod/onto/exploitation.owl#>"
};

List<String> SPARQL_KEYWORDS = ["base", "prefix", "select", "distinct", "reduced", "construct", "describe", "ask", "from", "named", "where", "order", "limit", "offset", "filter", "optional", "graph", "by", "asc", "desc", "as", "having", "undef", "values", "group", "minus", "in", "not", "service", "silent", "using", "insert", "delete", "union", "true", "false", "with", "data", "copy", "to", "move", "add", "create", "drop", "clear", "load"];

Map<String, String> SELECT_TEMPLATES = {
                                  "all properties":"distinct ?p where {?s ?p ?o}",
                                  "all types":"distinct ?type where {?s a ?type}", 
                                  "all entities of types":"distinct ?e ?eLabel where {?e a ?type . ?s http://www.w3.org/2004/02/skos/core#prefLabel ?eLabel} limit 50", 
                                  "all graphs":"distinct ?g ?gLabel where {graph ?g {?g http://www.w3.org/2000/01/rdf-schema#label ?gLabel}}",
                                  "number of triples":"(count(*) as ?dim) where {?s ?p ?o}",
                                  "creator(s) of graphs":"distinct ?creator where {?s http://purl.org/dc/terms/creator ?creator}"
                                  };

HintResults sparqlCompletion(CodeMirror editor, [HintsOptions options]) {

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

  Set<HintResult> suggestions = new Set<HintResult>();

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
      case "select":
        fillSelectTemplates(suggestions);
        break;
      default:
        fillKeywords(suggestions);
        break;
    }
  }
  
  return new HintResults.fromHints(suggestions.toList(),
      cursorPosition, cursorPosition);
}

void fillGraphs(Set<HintResult> suggestions, Iterable<EditableEndpoint> endpoints) {
  
  List<EditableEndpoint> sortedEndpoints = endpoints.where((EditableEndpoint e)=>!e.model.predefined).toList();
  sortedEndpoints.sort(compareEndpoints);
  
  sortedEndpoints.forEach((EditableEndpoint e){
    List<Graph> graphs = new List.from(e.model.graphs);
    graphs.sort(compareGraphs);
    graphs.map((Graph g) => new HintResult("<${g.uri}>", displayText: "${e.model.name} - ${g.label}"))
      .forEach((HintResult hr) => suggestions.add(hr));
    
  });
}

void fillServices(Set<HintResult> suggestions, Iterable<EditableEndpoint> endpoints) {
  List<EditableEndpoint> sortedEndpoints = endpoints.toList();
  sortedEndpoints.sort(compareEndpoints);
  
  sortedEndpoints.map((EditableEndpoint e) => new HintResult("[${e.model.name}]", displayText: e.model.name))
    .forEach((HintResult hr) => suggestions.add(hr));
}

void fillMatchingKeywords(Set<HintResult> suggestions, String word) {
  SPARQL_KEYWORDS.where((String k) => k.startsWith(word)).map((String u) =>  new HintResult(u.substring(word.length), displayText: u))
    .forEach((HintResult hr) => suggestions.add(hr));
}

void fillKeywords(Set<HintResult> suggestions) {
  SPARQL_KEYWORDS.map((String u) =>  new HintResult(u, displayText: u))
    .forEach((HintResult hr) => suggestions.add(hr));
}

void fillPrefixes(Set<HintResult> suggestions) {
  PREFIXES.keys.map((String key) =>  new HintResult(PREFIXES[key], displayText: key))
    .forEach((HintResult hr) => suggestions.add(hr));
}

void fillSelectTemplates(Set<HintResult> suggestions) {
  SELECT_TEMPLATES.keys.map((String key) =>  new HintResult(SELECT_TEMPLATES[key], displayText: key))
    .forEach((HintResult hr) => suggestions.add(hr));
}
