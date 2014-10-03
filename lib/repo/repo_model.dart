part of repo;

class Graph extends ListItem {
  String id;
  String name;
  String description;
  DateTime lastUpdate;
  String repository;
  String author;
  
  Graph(this.id, this.name, this.description, this.lastUpdate, this.repository, this.author);
  
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

