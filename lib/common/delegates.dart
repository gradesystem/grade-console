part of common;

typedef T Generator<T>(Map data);

DateFormat JSON_DATE_FORMAT = new DateFormat('y-M-dTH:m:s.SZ');


abstract class Keyed {
  
  dynamic get(String key);
  
  set(String key, dynamic val);
  
}

abstract class Delegate extends Keyed {
  
  final ObservableMap _bean = new ObservableMap();
  
  Delegate(Map bean) {
    _bean.addAll(bean);
  }
  
  ObservableMap get bean => _bean;
  
  get(String l) => _bean[l];
  DateTime getDate(String l) => bean.containsKey(l)?JSON_DATE_FORMAT.parse(get(l)):null;
  
  set(String l, value) => _bean[l] = value;
    
  List all(String l, Generator gen) => new ListDelegate(get(l),gen);
  
  put(String l, value) => _bean[l] = value;
  
  void onBeanChange(List<String> keys, void callback()) {
      bean.changes.expand((List<ChangeRecord> list) => list)
         .where((ChangeRecord record)=> record is MapChangeRecord)
         .where((MapChangeRecord record)=> keys.contains(record.key)).listen((_){callback();});
    }
  
  String toJson() => JSON.encode(bean);
}

class ListDelegate<E extends Delegate> extends ListBase<E> {
  
  final List _inner;
  final Generator<E> _gen;
  
  ListDelegate(this._inner,this._gen);
  
  int get length => _inner.length;

  void set length(int length) {
    _inner.length = length;
  }
  
  E operator [](int index) => _gen(_inner[index]);
  
  void operator[]=(int index,E e) { 
    _inner[index] = e.bean;
  }
}
