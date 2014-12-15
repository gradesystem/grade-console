part of editables;

abstract class EditableGradeEntity extends GradeEntity with Cloneable {
  
  EditableGradeEntity(Map bean):super(bean);
  
  String get id;
  set id(String value);
}

typedef EditableModel<T> EditableGenerator<T extends EditableGradeEntity>([T item]);

abstract class SubPageEditableModel<T extends EditableGradeEntity> {
  
  static String CLONED_NAME_SUFFIX = "_cloned";
  RegExp CLONED_NAME_REGEXP = new RegExp(r'(.*)_cloned(\d*)$');

  EventBus bus;
  EditableListService<T> service;
  EditableListItems<EditableModel<T>> storage;
  
  EditableGenerator<T> generator;

  SubPageEditableModel(this.bus, this.service, this.storage, this.generator) {
  }

  void addNew() {
    EditableModel<T> editableModel = generator();
    editableModel.newModel = true;

    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }

  void cancelEditing(EditableModel<T> item) {
    item.cancel();
    if (item.newModel) {
      storage.selected = null;
      storage.data.remove(item);
    }
  }

  void clone(EditableModel<T> original) {
    T cloned = original.model.clone();
    cloned.id = null;
    cloned.name = generateCloneName(cloned.name);
    
    EditableModel<T> editableModel = generator(cloned);
    editableModel.newModel = true;
    
    storage.data.add(editableModel);
    storage.selected = editableModel;
    editableModel.startEdit();
  }
  
  String generateCloneName(String name) {
    if (name == null) return name;
    Match match = CLONED_NAME_REGEXP.firstMatch(name);
    
    String originalName = match!=null?match.group(1):name;
    
    int number = 1;
    
    String cloneName = originalName + CLONED_NAME_SUFFIX;
    while(storage.findByName(cloneName)!=null) cloneName = originalName + CLONED_NAME_SUFFIX + (number++).toString();

    return cloneName;
  }

  void save(EditableModel<T> editableModel) {

    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });

    service.put(editableModel.model)
    .then((T result) => editableModel.save(result))
    .catchError((e) => onError(e, () => save(editableModel)))
    .whenComplete(() {
      timer.cancel();
      editableModel.synched();
      storage.sort();
    });

  }

  void remove(EditableModel<T> editableModel) {
    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });

    service.delete(editableModel.model).then((bool result) {
      storage.data.remove(editableModel);
      storage.selected = null;
    }).catchError((e) => onError(e, () => remove(editableModel))).whenComplete(() {
      timer.cancel();
      editableModel.synched();
    });

  }

  void loadAll() {
    storage.loading = true;
    storage.selected = null;
    service.getAll().then(_setData).catchError((e) {
      onError(e, loadAll);
      storage.data.clear();
      storage.loading = false;
    });
  }

  void _setData(List<T> items) {
    
    storage.data.clear();

    storage.data.addAll(items.map((T q) => generator(q)));

    storage.loading = false;

  }

  void onError(e, callback) {
    log.warning("error (source: $this): $e");
    bus.fire(new ToastMessage.alert("Ops we are having some problems communicating with the server", callback));
  }
}


abstract class EditableListItems<T extends EditableModel> extends ListItems<T> {
  
  EditableListItems([Comparator<T> comparator]):super(comparator) {
    onPropertyChange(data, #lastChangedItem, _notifySynchedDataChanged);
    onPropertyChange(data, #length, _notifySynchedDataChanged);
  }
  
  void _notifySynchedDataChanged() {
    notifyPropertyChange(#synchedData, null, synchedData);
  }
  
  @observable
  List<T> get synchedData => data.where((T e)=>!e.newModel).toList();
  
  T findByName(String name) => data.firstWhere((T item)=> item.model.name!=null && item.model.name.toLowerCase() == name.toLowerCase(), orElse:()=>null);
}

class EditableModel<T extends Cloneable> extends Observable {
  
  @observable
  bool newModel = false;
  
  @observable
  bool edit = false;
  
  @observable
  bool synching = false;

  @observable
  ObservableMap<String,bool> fieldsInvalidity = new ObservableMap();
  
  bool _valid = true;
  
  T _original;
  T _underEdit;
  
  EditableModel(T this._original) {
    fieldsInvalidity.changes.listen((_)=>updateValidity());
  }
  
  void updateValidity() {
    _valid = calculateFieldsValidity();
    notifyPropertyChange(#valid, null, _valid);
  }
  
  bool calculateFieldsValidity() => fieldsInvalidity.values.every((b)=>!b);
  
  bool isValid(String fieldName) => fieldsInvalidity.containsKey(fieldName) && !fieldsInvalidity[fieldName];
  
  @observable
  T get model => edit?_underEdit:_original;
  
  @observable
  bool get valid => _valid; 
  
  void startEdit() {
    edit = true;
    _underEdit = _original.clone();
    
    notifyPropertyChange(#model, _original, _underEdit);
  }
  
  void cancel() {
    edit = false;
    notifyPropertyChange(#model, _underEdit, _original);
    fieldsInvalidity.clear();
  }
  
  void save(T saved) {
    _original = saved;
    edit = false;
    newModel = false;
    notifyPropertyChange(#model, _underEdit, _original);
  }
  
  void sync() {
    synching = true;
  }
  
  void synched() {
    synching = false;
  }
  
  String toString() => "EditableModel $model";

}

abstract class Cloneable<T> {
  
  String get name;
  set name(String value);
  
  T clone();
}