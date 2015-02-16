part of lists;

abstract class ListItems<T extends Observable> extends Observable {
  
  Comparator<T> _comparator;
  
  StreamController<SelectionChange<T>> _selectionChanges;
  
  @observable
  T selected = null;
  
  @observable
  ObservedItemList<T> data = new ObservedItemList();
  
  @observable
  bool loading = false;
  
  ListItems([this._comparator]) {
    _selectionChanges = new StreamController.broadcast(sync: false);
  }
  
  void select(T value) {
    _selectionChanges.add(new SelectionChange<T>(value));
  }
  
  void selectFirst() {
    _selectionChanges.add(new SelectionChange<T>.first());
  }
  
  void clearSelection() {
    _selectionChanges.add(new SelectionChange<T>(null));
  }
  
  Stream<SelectionChange<T>> get selection => _selectionChanges.stream;
  
  void setData(List<T> items, [bool selectFirst = true]) {

    data.clear();
    
    if (_comparator!=null) items.sort(_comparator);
    data.addAll(items);

    if (selectFirst && data.isNotEmpty) this.selectFirst();
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

class SelectionChange<T> {
  bool selectFirst = false;
  T item;
  
  SelectionChange.first() {
    selectFirst = true;
  }
  
  SelectionChange(this.item);
  
  String toString() => "SelectionChange selectFirst: $selectFirst item: $item";
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
