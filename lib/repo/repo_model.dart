part of repo;

class Graph extends Delegate with ListItem, Observable {

  Graph(Map bean) : super(bean);
  
  DateTime  get date => getDate('date');
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

