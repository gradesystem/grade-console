part of datasets;

class Dataset extends Delegate with ListItem {

  Dataset(Map bean) : super(bean);
  
  DateTime  get date => getDate('date');
}


class ListItem {
 
  bool selected;
  
  dynamic get self => this;
}


abstract class Datasets extends Observable {
  
  @observable
  Dataset selected = null;
  
  @observable
  ObservableList<Dataset> data = new ObservableList();
  
  @observable
  bool loading = false;
}

