part of lists;

abstract class ListItem {
 
  bool selected;
  
  dynamic get self => this;
  
  String get title;
  String get subTitle;
}


abstract class ListItems<T extends ListItem> extends Observable {
  
  @observable
  T selected = null;
  
  @observable
  ObservableList<T> data = new ObservableList();
  
  @observable
  bool loading = false;
}

