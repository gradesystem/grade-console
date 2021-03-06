part of queries;

class QueryKeys {

  const QueryKeys();

  final String id = "id";
  final String endpoint = "endpoint";
  final String name = "name";
  final String note = "note";
  final String target = "target";
  final String graph = "graph";
  final String expression = "expression";
  final String parameters = "parameters";
  final String status = "status";
  
  final String status_published = "published";
  final String status_unpublished = "unpublished";
  final String status_system = "system";
}

class Query extends EditableGradeEntity with Filters, Observable {

  static QueryKeys K = const QueryKeys();

  static final RegExp regexp = new RegExp(r"!(\w+)");

  final String base_url;
  final String repo_path;

  ObservableList<String> _graphs = new ObservableList();
  
  @observable
  Doc expressionDoc;

  Query.fromBean(this.base_url, this.repo_path, Map bean) : super(bean) {
    _installGraphs();
    _listenChanges();
    expressionDoc = new Doc(bean[K.expression], "sparql");
  }

  Query(String base_url, String repo_path) : this.fromBean(base_url, repo_path, {
        K.name: "",
        K.expression: "",
        K.status:K.status_unpublished,
        K.graph: []
      });

  void _listenChanges() {
    onBeanChange([K.name, K.expression], () => notifyPropertyChange(#endpoint, null, endpoint));
    onBeanChange([K.expression], () => notifyPropertyChange(#parameters, null, parameters));
    onBeanChange([K.name], () => notifyPropertyChange(#name, null, name));
    onBeanChange([K.status], () {
      notifyPropertyChange(#status, null, status);
      notifyPropertyChange(#isSystem, null, isSystem);
      notifyPropertyChange(#isPublished, null, isPublished);
    }); 
    //we don't support graphs in bean map writing
  }

  //put the graphs in the bean in the graphs field and sets the graphs field as bean value
  void _installGraphs() {
    graphs = get(K.graph);
    set(K.graph, _graphs);
  }

  String get id => get(K.id);
  set id(String value) => set(K.id, value);

  String get name => get(K.name);
  set name(String value) {
    set(K.name, value);
  }
  
  String get status => get(K.status);
  set status(String value) {
    set(K.status, value);
  }

  @observable
  get graphs => _graphs;
  set graphs(List<String> newgraphs) {
    _graphs.clear();
    if (newgraphs != null) _graphs.addAll(newgraphs);
    notifyPropertyChange(#graphs, null, _graphs);
  }
  
  @observable
  bool get isSystem => get(K.status) == K.status_system;
  
  @observable
  bool get isPublished => get(K.status) == K.status_published;
  
  @observable
  bool get isUnpublished => get(K.status) == K.status_unpublished;

  Query clone() => new Query.fromBean(base_url, repo_path, new Map.from(bean));
  
  String calculateEndpointBase(Map<String,String> parameters) {
    Uri base = Uri.parse(base_url);
    
    String namePath = name!=null && name.isNotEmpty ? name:"~missing~";

    List<String> pathSegments = base.pathSegments;
    if (pathSegments.isNotEmpty) pathSegments = pathSegments.sublist(0,pathSegments.length - 1);
    String path = pathSegments.join("/");
    
    Uri uri = new Uri.http(base.authority, '${path}/service/${repo_path}/query/$namePath/results', parameters);
    String endpoint = uri.toString();
    
    //we remove the final question mark
    if (endpoint.endsWith("?")) endpoint = endpoint.substring(0, endpoint.length - 1);
    
    return endpoint;
  }

  //calculates endpoint
  @observable
  String get endpoint {

    Map<String, String> endpointParameters = {};
    for (String parameter in parameters) endpointParameters[parameter] = "...";

    return calculateEndpointBase(endpointParameters);
  }

  @observable
  List<String> get parameters {

    List<String> params = [];

    String exp = bean[K.expression];
    
    if (exp == null) return params;
    for (Match m in regexp.allMatches(exp)) params.add(m.group(1));

    return params;
  }
  
  String toString() => 'Query $name';
}

int compareQueries(EditableQuery eq1, EditableQuery eq2) {
  if (eq1 == null || eq1.model.name == null) return 1;
  if (eq2 == null || eq2.model.name == null) return -1;
  return compareIgnoreCase(eq1.model.name, eq2.model.name);
}

class Queries extends EditableListItems<EditableQuery> {
  
  @observable
  int unpublished = 0;
  
  @observable
  int published = 0;
  
  @observable
  int withErrors = 0;
  
  Queries():super.sorted(compareQueries) {
    onPropertyChange(data, #lastChangedItem, _notifyDerivedChangedAndCalculateStatistics);
    onPropertyChange(data, #length, _notifyDerivedChangedAndCalculateStatistics);
  }
  
  void _notifyDerivedChangedAndCalculateStatistics() {
    notifyPropertyChange(#invalidPublished, null, invalidPublished);
    
    unpublished = data.where((EditableModel<Query> et)=>et.model.isUnpublished).length;
    published = data.where((EditableModel<Query> et)=>et.model.isPublished).length;
    withErrors = data.where((EditableModel<Query> et)=>!et.valid).length;
  }

  bool containsName(String name) => data.any((EditableQuery eq) => eq != selected && eq.model.name != null && eq.model.name.toLowerCase() == name.toLowerCase());
  
  @observable
  List<EditableModel<Query>> get invalidPublished => data.where((EditableModel<Query> et)=>!et.edit && !et.valid && et.model.isPublished).toList();
 
  
}

class QuerySubPageModel extends SubPageEditableModel<Query> {

  QuerySubPageModel(PageEventBus bus, QueryService service, Queries storage, Endpoints endpoints) : super(bus, service, storage, ([Query query]) => generate(query != null ? query : new Query(service.base_url, service.path), endpoints, service)) {
    bus.on(ApplicationReady).listen((_) {
      loadAll();
    });
  }

  static EditableQuery generate(Query query, Endpoints endpoints, QueryService service) {
    //we are cloning
    if (query.id == null) query.bean[Query.K.status] = Query.K.status_unpublished;
    return new EditableQuery(query, endpoints, service);
  }

  QueryService get queryService => service;

  void runQuery(EditableQuery editableQuery, int limit, [RawFormat format = RawFormat.JSON]) {
    editableQuery.lastResult.history.clear(editableQuery.model);
    _run(editableQuery, editableQuery.model, editableQuery.parametersValues, queryService.runQuery, limit:limit, format:format);
  }
  
  void eatCrumb(EditableQuery editableQuery, Crumb crumb, int limit, [RawFormat format = RawFormat.JSON]) {
    Query resultQuery = editableQuery.model.clone();
    resultQuery.set(Query.K.expression, crumb.expression);
    resultQuery.set(Query.K.graph, crumb.graphs);
       
    _run(editableQuery, resultQuery, editableQuery.lastResult.lastParameters, queryService.runQuery, limit:limit, format:format);
  }
  
  void loadRaw(EditableQuery editableQuery, int limit, RawFormat format) {
    Result result = editableQuery.lastResult;
    Query resultQuery = editableQuery.model.clone();
    resultQuery.set(Query.K.expression, result.lastExpression);
    result.loadingRaw = true;
    queryService.runQuery(resultQuery, result.lastParameters, limit, format)
      .then((String raw){
      result.raws[format] = raw;
      result.loadingRaw = false;
    })
      .catchError((e){
      result.raws[format] = "n/a";
      result.loadingRaw = false;
    });
  }
  
  void _run(EditableQuery editableQuery, Query query, Map parameters, Future<String> runner(Query query, Map<String, String> parameters, int limit), {int limit : 100, RawFormat format : RawFormat.JSON}) {
    editableQuery.runQuery();
    editableQuery.lastResult.lastExpression = query.get(Query.K.expression);
    editableQuery.lastResult.lastParameters = parameters;
    runner(query, parameters, limit)
      .then((String result) => editableQuery.queryResult(format, result))
      .catchError((ErrorResponse e) {
      editableQuery.queryFailed(e);
      String message = e.isClientError()?
          "Uhm, may be this query is broken? Make sure it's a well-formed SELECT, CONSTRUCT, or DESCRIBE.":
          "Ouch. Something went horribly wrong...";
      bus.fire(new ToastMessage.alert(message, null, new GradeError(message, e.message, e.stacktrace)));
    });
  }
}

class EditableQuery extends EditableModel<Query> with Keyed {

  @observable
  bool queryRunning = false;

  @observable
  ErrorResponse lastError;

  @observable
  Result lastResult = new Result();

  @observable
  ObservableMap<String, String> parametersValues = new ObservableMap();

  @observable
  ObservableMap<String, bool> parametersInvalidity = new ObservableMap();

  bool _validParameters = true;

  bool _dirty = false;
  
  EndpointValidator endpointValidator;
  
  EndpointProvider endpointProvider;
  
  @observable
  PropertiesCache propertiesCache;

  EditableQuery(Query query, Endpoints endpoints, QueryService service) : super(query) {
    
    endpointValidator = new EndpointValidator(this, Query.K.target, Query.K.graph, endpoints);
    onPropertyChange(endpointValidator, #valid, ()=> notifyPropertyChange(#valid, null, valid));
    
    endpointProvider = new EndpointProvider(this, Query.K.target, Query.K.graph, endpoints);
    onPropertyChange(endpointProvider, #editableEndpoint, ()=>notifyPropertyChange(#targetEndpoint, null, targetEndpoint));
    
    propertiesCache = new PropertiesCache(service);
    onPropertyChange(this, #edit, (){
      if (edit) updatePropertiesCache();
      });
    
    //we want to listen on parameters value changes
    parametersInvalidity.changes.listen(_updateParametersValidity);

    parametersValues.changes.listen((_) {
      _setDirty(true);
      notifyPropertyChange(#queryEndpoint, null, queryEndpoint);
    });

    //we need to listen on the expression changes in the current model
    onPropertyChange(this, #model, _listenNewModel);

    //when query or parameters are edited we reset the last error
    onPropertyChange(this, #dirty, resetLastError);

  }
  
  void updatePropertiesCache() {
    propertiesCache.refresh(model);
  }

  get(key) => model.get(key);
  set(key, value) => model.set(key, value);
  
  EditableEndpoint get targetEndpoint => endpointProvider.editableEndpoint;
  
  @observable
  bool get valid => super.valid && (edit || endpointValidator.valid); 

  void _listenNewModel() {
    //when parameters list change we re-calculate the parameters validity
    onPropertyChange(model, #parameters, () {
      _updateParametersValidity(null);
      notifyPropertyChange(#queryEndpoint, null, queryEndpoint);
    });
    _updateParametersValidity(null);

    model.bean.changes.listen((_) {
      _setDirty(true);
      notifyPropertyChange(#queryEndpoint, null, queryEndpoint);
    });

    //for query properties not updated in bean like graphs
    onPropertyChange(model, #graphs, () => _setDirty(true));

    onPropertyChange(this, #model, () => _setDirty(false));
    
    onPropertyChange(model, #graphs, updatePropertiesCache);
    onPropertyChange(model.graphs, #length, updatePropertiesCache);
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
    lastResult.clean();
  }

  void queryResult(RawFormat rawFormat, String result) {
    queryRunning = false;
    if (rawFormat == RawFormat.JSON) lastResult.value = new ResultTable(JSON.decode(result));
    lastResult.raws[rawFormat] = result;
  }

  void queryFailed(ErrorResponse reason) {
    queryRunning = false;
    lastError = reason;
  }
  
  @observable
  String get queryEndpoint {

    Map<String, String> endpointParameters = {};
    for (String parameter in model.parameters) endpointParameters[parameter] = parametersValues[parameter]!=null && parametersValues[parameter].isNotEmpty ?parametersValues[parameter]:"~missing~";

    return model.calculateEndpointBase(endpointParameters);
  }

  String toString() => 'EditableQuery $model';
}

class ResultTable extends Delegate {

  ResultTable(Map bean) : super(bean);

  List<String> get headers => get("head")["vars"];
  List<Map<String, Map>> get rows => get("results")["bindings"];
}

class RawFormat {

  static UnmodifiableListView<RawFormat> values = new UnmodifiableListView([JSON, XML, NTRIPLES, JSONLD_TYPE, RDF_XML, TURTLE]);

  static RawFormat parse(String value) => values.firstWhere((RawFormat o) => o._value == value, orElse: () => null);

  final MediaType _value;
  final String _label;
  final String _mode;
  const RawFormat._internal(this._value, this._label, this._mode);
  
  toString() => 'Operation.$_label';

  MediaType get value => _value;
  String get label => _label;
  String get mode => _mode;

  static const JSON = const RawFormat._internal(MediaType.SPARQL_JSON, 'JSON-SR', 'application/json');
  static const XML = const RawFormat._internal(MediaType.SPARQL_XML, 'XML-SR', 'application/xml');
  static const NTRIPLES = const RawFormat._internal(MediaType.NTRIPLES, 'N-TRIPLES', 'text/n-triples');
  static const JSONLD_TYPE = const RawFormat._internal(MediaType.JSONLD, 'JSON-LD', 'application/ld+json');
  static const RDF_XML = const RawFormat._internal(MediaType.RDF_XML, 'RDF-XML', 'application/xml');
  static const TURTLE = const RawFormat._internal(MediaType.TURTLE, 'TURTLE', 'text/turtle');
}

class Result extends Observable {
  
  @observable
  ResultTable value;

  @observable
  bool loading = false;
  
  @observable
  ResultHistory history = new ResultHistory();
  
  @observable
  ObservableMap<RawFormat,String> raws = toObservable({});
  
  @observable
  bool loadingRaw = false;
  
  String lastExpression;
  Map<String,String> lastParameters;

  bool get hasValue => value != null;

  void clean() {
    value = null;
    raws.clear();
    loading = false;
    loadingRaw = false;
  }
}

class ResultHistory extends Observable {
  
  @observable
  List<Crumb> crumbs = toObservable([]);
  
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

  Crumb go(String uri, [DescribeType type = DescribeType.DESCRIBE_BY_SUBJECT]) {
    
    if (currentCrumb is DescribeCrumb && (currentCrumb as DescribeCrumb).uri == uri && (currentCrumb as DescribeCrumb).type == type) return currentCrumb;
    
    crumbs = toObservable(crumbs.sublist(0, currentIndex >= 0 ? currentIndex + 1 : 0));
    
    String expression = "describe <${uri}>";
    if (type == DescribeType.DESCRIBE_BY_SUBJECT) expression = "select ?graph ?subject ?predicate ?object where { graph ?graph {?subject ?predicate ?object} . filter (?subject = <${uri}>)}";
    if (type == DescribeType.DESCRIBE_BY_OBJECT) expression = "select ?graph ?subject ?predicate ?object where { graph ?graph {?subject ?predicate ?object} . filter (?object = <${uri}>)}";
    
    Crumb crumb = new DescribeCrumb(uri, expression, type);
    crumbs.add(crumb);
    currentIndex++;
    _notifyChanges();
    return crumb;
  }
  
  Crumb goIndex(int index) {
    if (index>=crumbs.length || index<-1) throw new Exception("Wrong index $index");
    currentIndex = index;
    _notifyChanges();
    return currentCrumb;
  }
  
  void removeLastCrumb() {
    if (currentIndex>0) {
      currentIndex--;
      crumbs = toObservable(crumbs.sublist(0, currentIndex + 1));
      _notifyChanges();
    }
  }
  
  void clear([Query query]) {
    Crumb start = (query!=null)? new Crumb(query.get(Query.K.expression), query.get(Query.K.graph), true): new Crumb(null, [], true);

    init(start);
  }
  
  void init(Crumb start) {
      crumbs.clear();
      
      crumbs.add(start);

      currentIndex = 0;
      _notifyChanges();
    }

  void _notifyChanges() {
    //print('canGoBack: $canGoBack canGoForward: $canGoForward currentIndex: $currentIndex uris: $uris');

    notifyPropertyChange(#canGoBack, null, canGoBack);
    notifyPropertyChange(#canGoForward, null, canGoForward);
    notifyPropertyChange(#currentCrumb, null, currentCrumb);
    notifyPropertyChange(#empty, null, empty);
  }

  bool get canGoBack => currentIndex >= 0;
  bool get canGoForward => crumbs.isNotEmpty && currentIndex < crumbs.length - 1;
  Crumb get currentCrumb => currentIndex >= 0 ? crumbs[currentIndex] : null;
  bool get empty => crumbs.isEmpty;
}

class Crumb {
  String expression;
  List<String> graphs;
  bool start;
  
  Crumb(this.expression, this.graphs, this.start);
  
  toString() => 'Crumb';
}

class DescribeCrumb extends Crumb {
  String uri;
  DescribeType type;
  
  DescribeCrumb(this.uri, String expression, this.type):super(expression,[],false);
  
  toString() => 'DescribeCrumb $uri $type';
}

class DescribeType {

  static UnmodifiableListView<DescribeType> values = new UnmodifiableListView([DESCRIBE_BY_SUBJECT, DESCRIBE_BY_OBJECT]);

  static DescribeType parse(String value) => values.firstWhere((DescribeType o) => o._value == value, orElse: () => null);

  final _value;
  const DescribeType._internal(this._value);
  toString() => 'DescribeType.$_value';

  String get value => _value;

  static const DESCRIBE_BY_SUBJECT = const DescribeType._internal('subject');
  static const DESCRIBE_BY_OBJECT = const DescribeType._internal('object');
}

class PropertiesCache extends Observable {
  QueryService service;
  Completer<List<String>> _cache;
  
  PropertiesCache(this.service);
  
  void refresh(Query target) {
    print('updating properties cache');
    _cache = new Completer();
    notifyPropertyChange(#properties, null, properties);
    
    Query query = target.clone();
    query.set(Query.K.expression, "select distinct ?p {?s ?p ?o}");
    service.runQuery(query, {}, 30).then((String result){
      Map json = JSON.decode(result);
      List bindings = json["results"]["bindings"];
      List<String> properties = bindings.map((binding)=>binding["p"]["value"]).toList();
      _cache.complete(properties);
    }).catchError((e)=>_cache.completeError(e));
  }
  
  @observable
  Future<List<String>> get properties => _cache!=null?_cache.future:null;
}
