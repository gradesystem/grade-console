part of home;


@CustomTag("page-tile")
class PageTile extends PolymerElement with Filters {
  
  static List<List<String>> notificationsSets = [[],[],['error', 'social:notifications'],[]];
  
  static Random rng = new Random();

  @published String name;
  @published String resource_name;
  
  @published PageStatistics statistics = dummyStats();
  
  PageTile.created() : super.created();

  void tileSelected() {
    this.fire("tile-selected", detail:name);
  }

 static PageStatistics dummyStats() {
   
   int count = 1 + rng.nextInt(20);
   DateTime date = new DateTime.now().add(new Duration(days: -count));
   
   List<List<String>> notificationsSets = [['error'],[],['error', 'social:notifications'],[]];
   
   return new PageStatistics(count, date, toObservable(notificationsSets[rng.nextInt(4)]));
 }
}

class PageStatistics extends Observable {
  
  @observable
  int count;
  
  @observable
  DateTime date;
  
  @observable
  ObservableList<String> notifications = toObservable([]);
  
  PageStatistics(this.count, this.date, this.notifications);
}
