part of home;

@CustomTag("page-tile")
class PageTile extends PolymerElement {
  
  static DateFormat formatter = new DateFormat('yyyy-MM-dd');

  @published String name;
  @published String theme;
  
  @published num hratio;
  @published num wratio;
  
  @published PageStatistics statistics;
  
  PageTile.created() : super.created();

  void tileSelected() {
    this.fire("tile-selected", detail:name);
  }
  
  uppercase(String str) => str.toUpperCase();
  format(DateTime date) => formatter.format(date);

}

class PageStatistics extends Observable {
  
  @observable
  int count;
  
  @observable
  String name;
  
  @observable
  DateTime date;
  
  @observable
  ObservableList<String> notifications;
  
  PageStatistics(this.count, this.name, this.date, this.notifications);
}
