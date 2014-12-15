part of lists;

abstract class ListItems<T extends Observable> extends Observable {
  
  Comparator<T> _comparator;
  
  @observable
  T selected = null;
  
  @observable
  ObservedItemList<T> data = new ObservedItemList();
  
  @observable
  bool loading = false;
  
  ListItems([this._comparator]) {
    if (_comparator!=null) {
      data.listChanges
      .where((List<ListChangeRecord> records)=> records.any((ListChangeRecord record)=>record.addedCount>0 || record.removed.isNotEmpty))
      .listen((_)=>_sort());
    }
  }
  
  void _sort() {
    loading = true;
    List<T> copy = new List.from(data);
    copy.sort(_comparator);
    data.clear();
    data.addAll(copy);
    loading = false;
  }
  
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
