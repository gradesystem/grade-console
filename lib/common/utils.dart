part of common;

class ObservedItemList<E extends Observable> extends ObservableList<E> {
  
  Map<E,StreamSubscription> subscriptions = {};
  
  E _lastChangedItem;
  
  @observable
  E get lastChangedItem => _lastChangedItem;
  
  void setAll(int index, Iterable<E> iterable) {
    if (iterable is! List && iterable is! Set) {
      iterable = iterable.toList();
    }
    iterable.forEach(_subscribe);
    super.setAll(index, iterable);
  }
  
  void add(E value) {
    _subscribe(value);
    super.add(value);
  }
  
  void addAll(Iterable<E> iterable) {
    if (iterable is! List && iterable is! Set) {
      iterable = iterable.toList();
    }
    iterable.forEach(_subscribe);
    super.addAll(iterable);
  }
  
  bool remove(Object element) {
    _unsuscribe(element);
    return super.remove(element);
  }
  
  void removeRange(int start, int end) {
    sublist(start,end).forEach(_unsuscribe);
    super.removeRange(start, end);
  }
  
  void insertAll(int index, Iterable<E> iterable) {
    if (iterable is! List && iterable is! Set) {
      iterable = iterable.toList();
    }
    iterable.forEach(_subscribe);
    super.insertAll(index, iterable);
  }
  
  void insert(int index, E element) {
    _subscribe(element);
    super.insert(index, element);
  }
  
  E removeAt(int index) {
    _unsuscribe(super[index]);
    return super.removeAt(index);
  }
  
  void _subscribe(E item) {
    StreamSubscription subscription = item.changes.listen((_)=>_fireEvent(item));
    subscriptions[item] = subscription; 
  }
  
  void _unsuscribe(E item) {
    StreamSubscription subscription = subscriptions[item];
    if (subscription!=null) subscription.cancel();
  }
  
  void _fireEvent(E item) {
    _lastChangedItem = item;
    notifyPropertyChange(#lastChangedItem, null, _lastChangedItem);
  }
}

class GradeListPathObserver<E, P> extends ChangeNotifier {
  final ObservableList<E> list;
  final String _itemPath;
  final List<PathObserver> _observers = <PathObserver>[];
  StreamSubscription _sub;
  bool _scheduled = false;
  Iterable<P> _value;

  GradeListPathObserver(this.list, String path)
      : _itemPath = path {

    // TODO(jmesserly): delay observation until we are observed.
    _sub = list.listChanges.listen((records) {
      for (var record in records) {
        _observeItems(record.addedCount - record.removed.length);
      }
      _scheduleReduce(null);
    });

    _observeItems(list.length);
    _reduce();
  }

  @reflectable Iterable<P> get value => _value;

  void dispose() {
    if (_sub != null) _sub.cancel();
    _observers.forEach((o) => o.close());
    _observers.clear();
  }

  void _reduce() {
    _scheduled = false;
    var newValue = _observers.map((o) => o.value);
    _value = notifyPropertyChange(#value, _value, newValue);
  }

  void _scheduleReduce(_) {
    if (_scheduled) return;
    _scheduled = true;
    scheduleMicrotask(_reduce);
  }

  void _observeItems(int lengthAdjust) {
    if (lengthAdjust > 0) {
      for (int i = 0; i < lengthAdjust; i++) {
        int len = _observers.length;
        var pathObs = new PathObserver(list, '[$len].$_itemPath');
        pathObs.open(_scheduleReduce);
        _observers.add(pathObs);
      }
    } else if (lengthAdjust < 0) {
      for (int i = 0; i < -lengthAdjust; i++) {
        _observers.removeLast().close();
      }
    }
  }
}

int compareIgnoreCase(String s1, String s2) => s1.toLowerCase().compareTo(s2.toLowerCase());