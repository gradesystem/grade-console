part of lists;

abstract class ListItems<T extends Observable> extends Observable {
  
  Comparator<T> _comparator;
  
  @observable
  T selected = null;
  
  @observable
  ObservedItemList<T> data = new ObservedItemList();
  
  @observable
  bool loading = false;
  
  ListItems([this._comparator]);
  
  void setData(List<T> items, [bool selectFirst = true]) {

    data.clear();
    
    if (_comparator!=null) items.sort(_comparator);
    data.addAll(items);

    if (selectFirst && data.isNotEmpty) selected = data.first;
  }
  
  void addItem(T item) {
    if (_comparator!=null) _insertSorted(item);
    else data.add(item);
  }
  
  void _insertSorted(T item) {
    int i = 0;
    while(i<data.length && _comparator(item, data[i])>=0) i++;
    data.insert(i, item);
  }
 
  void sortItem(T item) {
    data.remove(item);
    _insertSorted(item);
    notifyPropertyChange(#selected, null, selected);
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
