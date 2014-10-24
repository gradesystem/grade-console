part of lists;

abstract class ListItem {
 
  bool selected;
  
  dynamic get self => this;

}


abstract class ListItems<T extends ListItem> extends Observable {
  
  @observable
  T selected = null;
  
  @observable
  ObservableList<T> data = new ObservableList();
  
  @observable
  bool loading = false;
}
