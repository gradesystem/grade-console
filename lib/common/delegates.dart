part of common;

typedef T Generator<T>(Map data);

DateFormat JSON_DATE_FORMAT = new DateFormat('yyyy/MM/dd');

abstract class Delegate {
  
  final Map _bean;
  
  Delegate(this._bean);
  
  Delegate.from(Delegate other): this._bean = new Map.from(other._bean);
  
  get bean => _bean;
  
  get(String l) => _bean[l];
  getDate(String l) => JSON_DATE_FORMAT.parse(get(l));
  
  set(String l, value) => _bean[l] = value;
    
  List _all(String l, Generator gen) => new ListDelegate(get(l),gen);
  
  put(String l, value) => _bean[l] = value;
  
  noSuchMethod(Invocation invocation) {
    
    return invocation.isGetter ? 
                  get(MirrorSystem.getName(invocation.memberName)):
                  invocation.isSetter ? 
                        put(MirrorSystem.getName(invocation.memberName), invocation.positionalArguments[0])
                        : super.noSuchMethod(invocation);
   }
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
