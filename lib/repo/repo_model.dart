part of repo;

class Graph extends Delegate with ListItem {

  Graph(Map bean) : super(bean);
  
  DateTime  get lastUpdate => getDate('lastUpdate');
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

