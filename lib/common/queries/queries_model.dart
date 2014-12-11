part of queries;

class QueryKeys {

  const QueryKeys();

  final String id = "http://gradesystem.io/onto#id";
  final String endpoint = "http://gradesystem.io/onto/query.owl#endpoint";
  final String name = "http://gradesystem.io/onto/query.owl#name";
  final String note = "http://gradesystem.io/onto/query.owl#note";
  final String target = "http://gradesystem.io/onto/query.owl#target";
  final String graph = "http://gradesystem.io/onto/query.owl#graph";
  final String expression = "http://gradesystem.io/onto/query.owl#expression";
  final String parameters = "http://gradesystem.io/onto/query.owl#parameters";
  final String predefined = "http://gradesystem.io/onto/query.owl#predefined";
}

class Query extends EditableGradeEntity with Filters, Observable {

  static QueryKeys K = const QueryKeys();

  static final RegExp regexp = new RegExp(r"!(\w+)");

  final String base_url;
  final String repo_path;

  ObservableList<Graph> _graphs = new ObservableList();

  Query.fromBean(this.base_url, this.repo_path, Map bean) : super(bean) {
    _syncGraphs();
    _listenChanges();
  }

  Query._clone(this.base_url, this.repo_path, Map bean) : super(bean) {
    graphs = get(K.graph);
    set(K.graph, _graphs);
    _listenChanges();
  }

  Query(String base_url, String repo_path) : this.fromBean(base_url, repo_path, {
        K.name: "",
        K.expression: "",
        K.predefined: false,
        K.graph: []
      });

  void _listenChanges() {
    onBeanChange([K.name, K.expression], () => notifyPropertyChange(#endpoint, null, endpoint));
    onBeanChange([K.expression], () => notifyPropertyChange(#parameters, null, parameters));
    onBeanChange([K.name], () => notifyPropertyChange(#name, null, name));
    //we don't support graphs in bean map writing
  }

  void _syncGraphs() {
    graphs = get(K.graph);
    set(K.graph, _graphs);
  }

  String get id => get(K.id);
  set id(String value) => set(K.id, value);

  String get name => get(K.name);
  set name(String value) {
    set(K.name, value);
  }

  @observable
  get graphs => _graphs;
  set graphs(List<Graph> newgraphs) {
    _graphs.clear();
    if (newgraphs != null) _graphs.addAll(newgraphs);
    notifyPropertyChange(#graphs, null, _graphs);
  }

  bool get predefined => get(K.predefined);

  Query clone() {
    return new Query._clone(base_url, repo_path, new Map.from(bean));
  }

  //calculates endpoint
  @observable
  String get endpoint {

    Map<String, String> endpointParameters = {};
    for (String parameter in parameters) endpointParameters[parameter] = "...";

    Uri base = Uri.parse(base_url);
    Uri uri = new Uri.http(base.authority, '${base.path}/service/${repo_path}/query/${bean[K.name]}/results', endpointParameters);

    String endpoint = uri.toString();

    //we remove the final question mark
    if (endpoint.endsWith("?")) endpoint = endpoint.substring(0, endpoint.length - 1);

    return endpoint;
  }

  @observable
  List<String> get parameters {

    List<String> params = [];

    String exp = bean[K.expression];
    
    if (exp == null) return params;
    for (Match m in regexp.allMatches(exp)) params.add(m.group(1));

    return params;
  }
}

class Queries extends EditableListItems<EditableQuery> {

  bool containsName(String name) => data.any((EditableQuery eq) => eq != selected && eq.model.name != null && eq.model.name.toLowerCase() == name.toLowerCase());
}

class QuerySubPageModel extends SubPageEditableModel<Query> {

  QuerySubPageModel(EventBus bus, QueryService service, Queries storage) : super(bus, service, storage, ([Query query]) => generate(query != null ? query : new Query(service.base_url, service.path))) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }

  static EditableQuery generate(Query query) {
    //we are cloning
    if (query.id == null) query.bean[Query.K.predefined] = false;
    return new EditableQuery(query);
  }

  QueryService get queryService => service;

  void runQueryByName(EditableQuery editableQuery) {
    editableQuery.runQuery();

    queryService.runQueryByName(editableQuery.model, editableQuery.parametersValues).then((QueryResult r) => editableQuery.queryResult(r)).catchError((e) => editableQuery.queryFailed(e));
  }

  void runQuery(EditableQuery editableQuery) {
    editableQuery.runQuery();
    queryService.runQuery(editableQuery.model, editableQuery.parametersValues).then((QueryResult r) => editableQuery.queryResult(r)).catchError((e) => editableQuery.queryFailed(e));
  }

  void describeResultUri(EditableQuery editableQuery, String resultUri) {
    editableQuery.runQuery();
    Query resultQuery = editableQuery.model.clone();
    resultQuery.set(Query.K.expression, _buildQuery(resultUri));
    queryService.runQuery(resultQuery, {}).then((QueryResult r) => editableQuery.queryResult(r)).catchError((e) => editableQuery.queryFailed(e));
  }

  String _buildQuery(String resultUri) => "describe <$resultUri>";
}

class EditableQuery extends EditableModel<Query> with Keyed {

  @observable
  bool queryRunning = false;

  @observable
  ErrorResponse lastError;

  @observable
  QueryResult lastQueryResult;

  @observable
  ResultHistory history = new ResultHistory();

  @observable
  ObservableMap<String, String> parametersValues = new ObservableMap();

  @observable
  ObservableMap<String, bool> parametersInvalidity = new ObservableMap();

  bool _validParameters = true;

  bool _dirty = false;

  EditableQuery(Query query) : super(query) {
    //we want to listen on parameters value changes
    parametersInvalidity.changes.listen(_updateParametersValidity);

    parametersValues.changes.listen((_) => _setDirty(true));

    //we need to listen on the expression changes in the current model
    onPropertyChange(this, #model, _listenNewModel);

    //when query or parameters are edited we reset the last error
    onPropertyChange(this, #dirty, resetLastError);

  }

  get(key) => model.get(key);
  set(key, value) => model.set(key, value);

  void _listenNewModel() {
    //when parameters list change we re-calculate the parameters validity
    onPropertyChange(model, #parameters, () => _updateParametersValidity(null));
    _updateParametersValidity(null);

    model.bean.changes.listen((_) => _setDirty(true));

    //for query properties not updated in bean like graphs
    onPropertyChange(model, #graphs, () => _setDirty(true));

    onPropertyChange(this, #model, () => _setDirty(false));
  }

  void _setDirty(bool dirty) {
    _dirty = dirty;
    notifyPropertyChange(#dirty, null, _dirty);
  }

  //true if the query or his parameters have been modified after last editing
  bool get dirty => _dirty;

  void resetLastError() {
    lastError = null;
  }

  void _updateParametersValidity(_) {
    List<String> parameters = model.parameters;
    _validParameters = parameters.every((String name) => parametersInvalidity.containsKey(name) && !parametersInvalidity[name]);
    notifyPropertyChange(#validParameters, null, _validParameters);
  }

  @observable
  bool get validParameters => _validParameters;


  void runQuery() {
    queryRunning = true;
    _setDirty(false);
    resetLastError();
    lastQueryResult = null;
  }

  void queryResult(QueryResult result) {
    queryRunning = false;
    lastQueryResult = result;
  }

  void queryFailed(ErrorResponse reason) {
    queryRunning = false;
    lastError = reason;
  }
  
  String get queryEndpoint {

    Map<String, String> endpointParameters = {};
    for (String parameter in model.parameters) endpointParameters[parameter] = parametersValues[parameter];

    Uri base = Uri.parse(model.base_url);
    Uri uri = new Uri.http(base.authority, '${base.path}/service/${model.repo_path}/query/${model.bean[Query.K.name]}/results', endpointParameters);

    String endpoint = uri.toString();

    //we remove the final question mark
    if (endpoint.endsWith("?")) endpoint = endpoint.substring(0, endpoint.length - 1);

    return endpoint;
  }

}

class QueryResult extends Delegate {

  String raw;

  QueryResult(this.raw, Map bean) : super(bean);

  List<String> get headers => get("head")["vars"];
  List<Map<String, String>> get rows => get("results")["bindings"];
}

class Result extends Observable {

  @observable
  QueryResult value;

  @observable
  bool loading = false;

  bool get hasValue => value != null;

  void clean() {
    value = null;
    loading = false;
  }
}

class ResultHistory extends Observable {
  
  @observable
  List<String> uris = toObservable([]);
  
  @observable
  int currentIndex = -1;

  void goBack() {
    if (!canGoBack) throw new Exception("Can't go back");
    currentIndex--;
    _notifyChanges();
  }

  void goForward() {
    if (!canGoForward) throw new Exception("Can't go forward");
    currentIndex++;
    _notifyChanges();
  }

  void go(String uri) {
    uris = toObservable(uris.sublist(0, currentIndex >= 0 ? currentIndex + 1 : 0));
    uris.add(uri);
    currentIndex++;
    _notifyChanges();
  }
  
  void goIndex(int index) {
    if (index>=uris.length || index<-1) throw new Exception("Wrong index $index");
    currentIndex = index;
    _notifyChanges();
  }

  void _notifyChanges() {
    //print('canGoBack: $canGoBack canGoForward: $canGoForward currentIndex: $currentIndex uris: $uris');

    notifyPropertyChange(#canGoBack, null, canGoBack);
    notifyPropertyChange(#canGoForward, null, canGoForward);
    notifyPropertyChange(#currentUri, null, currentUri);
    notifyPropertyChange(#empty, null, empty);
  }

  bool get canGoBack => currentIndex >= 0;
  bool get canGoForward => uris.isNotEmpty && currentIndex < uris.length - 1;
  String get currentUri => currentIndex >= 0 ? uris[currentIndex] : null;
  bool get empty => currentIndex == -1;
}
