part of lists;


abstract class ListItems<T> extends Observable {
  
  @observable
  T selected = null;
  
  @observable
  ObservableList<T> data = new ObservableList();
  
  @observable
  bool loading = false;
}

class ListsUnion<T> extends Observable {
  
  ObservableList<ObservableList<T>> lists = new ObservableList();
  ObservableList<T> union = new ObservableList();
  
  void addList(ObservableList<T> list) {
    lists.add(list);
    list.listChanges.every((_){updateUnion();});
  }
  
  void updateUnion() {
    union.clear();
    lists.forEach((List<T> list)=>union.addAll(list));
    notifyPropertyChange(#items, null, union);
  }
  
  ObservableList<T> get items => union;
}
