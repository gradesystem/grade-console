part of home;


@CustomTag("page-tile")
class PageTile extends PolymerElement with Filters {
  
  static List<List<String>> notificationsSets = [[],[],['error', 'social:notifications'],[]];
  
  static Random rng = new Random();

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
  List<String> notifications = toObservable([]);
  
  PageStatistics(this.count, this.date, this.notifications);
}
