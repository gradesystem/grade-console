part of home;


@CustomTag("page-tile")
class PageTile extends PolymerElement with Filters {
  
  Map notificationsSets = {'error':'warning'};

  @published String name;
  @published String resource_name;
  
  @published PageStatistics statistics;
  
  PageTile.created() : super.created();

  void tileSelected() {
    this.fire("tile-selected", detail:name);
  }
}

class PageStatistics extends Observable {
  
  @observable
  int count;
  
  @observable
  DateTime date;
  
  @observable 
  bool loaded = false;
  
  @observable
  List<String> notifications = toObservable([]);
  
  PageStatistics(this.count, this.date);
}