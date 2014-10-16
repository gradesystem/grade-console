part of common;

typedef bool FilterFunction(item, String term);

class Filters {
  
  static DateFormat formatter = new DateFormat('yyyy-MM-dd');
  
  String uppercase(String str) => str.toUpperCase();
  String lowercase(String str) => str.toLowerCase();
  String format(DateTime date) => formatter.format(date);
  
  String suffix(String str) {
    int index = str.lastIndexOf(new RegExp(r'(/|#)'));
    if (index<0) return "";
    return str.substring(index+1);
  }
  
  String start(String str) {
    int index = str.lastIndexOf(new RegExp(r'(/|#)'));
    if (index<0) return str;
    return str.substring(0,index+1);
  }
  
  filter(String term, FilterFunction filterFunction) => (List items) => term.isEmpty ? items : toObservable(items.where((item)=>filterFunction(item, term)).toList());
}