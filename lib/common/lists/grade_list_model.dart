part of lists;

abstract class ListItems<T extends Observable> extends Observable {
  
  @observable
  T selected = null;
  
  @observable
  ObservedItemList<T> data = new ObservedItemList();
  
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
