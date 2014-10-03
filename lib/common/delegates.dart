part of common;

typedef T Generator<T>(Map data);

abstract class Delegate {
  
  final Map _bean;
  
  Delegate(this._bean);
  
  get bean => _bean;
  
  _get(String l) => _bean[l];
    
  List _all(String l, Generator gen) => new ListDelegate(_get(l),gen);
  
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