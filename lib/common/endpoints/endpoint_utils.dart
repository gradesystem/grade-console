part of endpoints;

int compareGraphs(Graph g1, Graph g2) {
  if (g1 == null || g1.label == null) return 1;
  if (g2 == null || g2.label == null) return -1;
  return compareIgnoreCase(g1.label, g2.label);
}

int compareEndpoints(EditableEndpoint ee1, EditableEndpoint ee2) {
  if (ee1 == null || ee1.model.name == null) return 1;
  if (ee2 == null || ee2.model.name == null) return -1;
  return compareIgnoreCase(ee1.model.name, ee2.model.name);
}