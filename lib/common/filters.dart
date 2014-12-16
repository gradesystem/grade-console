part of common;

typedef bool FilterFunction(item, String term);

class Filters {
  
  static DateFormat formatter = new DateFormat('yyyy-MM-dd');
  
  static DateFormat time_formatter = new DateFormat('HH:mm:ss.SSS');
  
  static RegExp suffix_start_exp = new RegExp(r'(/|#)');
  
  uppercase(o) => o is String && o != null ? o.toUpperCase() : o;
  lowercase(o) => o is String && o != null ? o.toLowerCase() : o;
  trim(o) => o is String && o != null ? o.trim() : o;
  split(o) => o is String && o != null ? o.split('\n') : o;
  tabToSpace(o) => o is String && o != null ? o.replaceAll('\t', '    ') : o;
  isHttpUri(o) => o is String && o != null && o.startsWith("http://");
  
  String format(DateTime date) => formatter.format(date);
  String formatEpoch(int milliseconds) => milliseconds != null  ? time_formatter.format(new DateTime.fromMillisecondsSinceEpoch(milliseconds)):milliseconds;
  
  String suffixIfPresent(String s) => suffix(s, s);
  
  String suffix(String str, [String alternative]) {
    if (str == null) return null;
    int index = str.lastIndexOf(suffix_start_exp);
    if (index<0) return alternative!=null?alternative:"";
    return str.substring(index+1);
  }
  
  String start(String str) {
    int index = str.lastIndexOf(new RegExp(r'(/|#)'));
    if (index<0) return str;
    return str.substring(0,index+1);
  }
  
  filter(String term, FilterFunction filterFunction) => (List items) => term == null || term.isEmpty ? items : toObservable(items.where((item)=>filterFunction(item, term)).toList()); 
  sort(Comparator comparator) => (List items) {
    if (items == null) return null;
    List copy = new List.from(items);
    copy.sort(comparator);
    return copy;
  };
  
  partialOrdering(List<String> partialOrdering) {
    return (Map toOrder) {
      List<String> ordered = new List<String>();
      
      for (String orderedValue in partialOrdering) {
        if (toOrder.containsKey(orderedValue)) ordered.add(orderedValue);
      }
      
//      for (String toOrderValue in toOrder.keys) {
//         if (!ordered.contains(toOrderValue)) ordered.add(toOrderValue);
//      }
      return ordered;
    };
  }  
}
