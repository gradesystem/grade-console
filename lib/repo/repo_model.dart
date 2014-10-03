part of repo;

class Graph extends Delegate with ListItem {

  Graph(Map bean) : super(bean);
  
  String get id => get('id');
  
  String  get name => get('name');
  String  get description => get('description');
  DateTime  get lastUpdate => getDate('lastUpdate');
  String get repository => get('repository');
  String  get author => get('author');
  
  String toString()=> "Graph id: $id, name: $name";
}

class ListItem {
  
  bool selected;
  
  dynamic get self => this;
}

@Injectable()
class Storage extends Observable {
  
  @observable
  List<Graph> data;
  
  @observable
  Graph selected;
  
  @observable
  bool loading;
}

