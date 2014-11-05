part of lists;


abstract class ListItems<T> extends Observable {
  
  @observable
  T selected = null;
  
  @observable
  ObservableList<T> data = new ObservableList();
  
  @observable
  bool loading = false;
}
