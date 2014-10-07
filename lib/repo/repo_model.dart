part of repo;

class Graph extends Delegate with ListItem {

  Graph(Map bean) : super(bean);
  
  DateTime  get date => getDate('date');
}


class ListItem {
 
  bool selected;
  
  dynamic get self => this;
}


@Injectable()
class Graphs extends Observable {
  
  @observable
  Graph selected;
  
  @observable
  List<Graph> data;
  
  @observable
  bool loading;
}

