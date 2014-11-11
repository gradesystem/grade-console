part of common;

abstract class Model {} 

class EditableModel<T extends Cloneable<T>> extends Observable {
  
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
  
  EditableModel(this._original) {
    fieldsInvalidity.changes.listen(_updateValidity);
  }
  
  void _updateValidity(_) {
    _valid = fieldsInvalidity.values.every((b)=>!b);
    notifyPropertyChange(#valid, null, _valid);
  }
  
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
  
  void save() {
    _original = _underEdit;
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

}

abstract class Cloneable<T> {
  
  T clone();
}

