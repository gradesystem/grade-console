part of common;

typedef bool FilterFunction(item, String term);

class Filters {
  
  static DateFormat formatter = new DateFormat('yyyy-MM-dd');
  
  String uppercase(String str) => str.toUpperCase();
  String lowercase(String str) => str.toLowerCase();
  String format(DateTime date) => formatter.format(date);
  
  filter(String term, FilterFunction filterFunction) => (List items) => term.isEmpty ? items : toObservable(items.where((item)=>filterFunction(item, term)).toList());
}