part of lists;

abstract class EditableListItems<T extends EditableModel> extends ListItems<T> {
  
  EditableListItems() {
    onPropertyChange(data, #lastChangedItem, _notifySynchedDataChanged);
    onPropertyChange(data, #length, _notifySynchedDataChanged);
  }
  
  void _notifySynchedDataChanged() {
    notifyPropertyChange(#synchedData, null, synchedData);
  }
  
  @observable
  List<T> get synchedData => data.where((T e)=>!e.newModel).toList();
}

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
