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

  PageEventBus bus;
  EditableListService<T> service;
  EditableListItems<EditableModel<T>> storage;
  
  EditableGenerator<T> generator;

  SubPageEditableModel(this.bus, this.service, this.storage, this.generator) {
  }

  void addNew() {
    EditableModel<T> editableModel = generator();
    editableModel.newModel = true;

    storage.addItem(editableModel);
    storage.select(editableModel);
    
    editableModel.startEdit();
  }

  void cancelEditing(EditableModel<T> item) {
    item.cancel();
    if (item.newModel) {
      storage.clearSelection();
      storage.data.remove(item);
    }
  }

  void clone(EditableModel<T> original) {
    T cloned = original.model.clone();
    cloned.id = null;
    cloned.name = generateCloneName(cloned.name);
    
    EditableModel<T> editableModel = generator(cloned);
    editableModel.newModel = true;
    
    storage.addItem(editableModel);
    storage.select(editableModel);
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
    .then((T result) {
      editableModel.save(result);
      storage.sortItem(editableModel);
      saved(editableModel);
    })
    .catchError((e) => onError(e, () => save(editableModel)))
    .whenComplete(() {
      timer.cancel();
      editableModel.synched();
    });

  }
  
  void saved(EditableModel<T> editableModel) {
  }

  void remove(EditableModel<T> editableModel) {
    Timer timer = new Timer(new Duration(milliseconds: 200), () {
      editableModel.sync();
    });

    service.delete(editableModel.model).then((bool result) {
      storage.clearSelection();
      storage.data.remove(editableModel);
      removed(editableModel);
    }).catchError((e) => onError(e, () => remove(editableModel))).whenComplete(() {
      timer.cancel();
      editableModel.synched();
    });

  }
  
  void removed(EditableModel<T> editableModel) {
  }

  void loadAll([bool selectFirst = true]) {
    storage.loading = true;
    storage.clearSelection();
    service.getAll()
    .then((List<T> items){
      storage.setData(items.map((T q) => generator(q)).toList(), selectFirst);
      })
    .catchError((e) {
      onError(e, loadAll);
      storage.data.clear();
    }).whenComplete(() {
      storage.loading = false;
    });
  }

  void onError(e, callback) {
    log.warning("error (source: $this): $e");
    String message = "Ops we are having some problems communicating with the server";
    if (e is ErrorResponse) bus.fire(new ToastMessage.alert(message, callback, new GradeError(message, e.message, e.stacktrace)));
    else if (e is Error) bus.fire(new ToastMessage.alert(message, callback, new GradeError("$e", "$e", e.stackTrace.toString())));
    else bus.fire(new ToastMessage.alert(message, callback, new GradeError("Unknow error type", "Unknow error type", "$e")));
  }
}


abstract class EditableListItems<T extends EditableModel> extends ListItems<T> {
  
  EditableListItems.sorted(Comparator<T> comparator):super(comparator) {
    onPropertyChange(data, #lastChangedItem, _notifySynchedDataChanged);
    onPropertyChange(data, #length, _notifySynchedDataChanged);
  }
  
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
  
  T get original => _original;
  
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
