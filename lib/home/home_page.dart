part of home;

@CustomTag(HomePage.name) 
class HomePage extends PolymerElement {
 
  static const name = "home-page";
  static List<String> names = ['datasets', 'tasks', 'running', 'datasets'];
  static List<List<String>> notificationsSets = [[],[],['error', 'social:notifications'],[]];
  
  static Random rng = new Random();
  int seed = 0;
  
  HomePage.created() : super.created();
  
  PageStatistics generateStatistics() {
    
    int count = 1 + rng.nextInt(20);
    int index = (seed++/ 2).floor() % names.length;
    String name = names[index];
    DateTime date = new DateTime.now().add(new Duration(days: -count));
    
    List<String> notifications = toObservable(notificationsSets[index]);

    return new PageStatistics(count, name, date, notifications);
  }
}
