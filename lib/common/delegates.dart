part of common;

typedef T Generator<T>(Map data);

DateFormat JSON_DATE_FORMAT = new DateFormat('yyyy/MM/dd');

abstract class Delegate {
  
  
  
  final Map _bean;
  
  Delegate(this._bean);
  
  get bean => _bean;
  
  get(String l) => _bean[l];
  getDate(String l) => JSON_DATE_FORMAT.parse(get(l));
    
  List _all(String l, Generator gen) => new ListDelegate(get(l),gen);
  
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