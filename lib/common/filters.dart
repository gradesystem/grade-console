part of common;

class Filters {
  
  static DateFormat formatter = new DateFormat('yyyy-MM-dd');
  
  String uppercase(String str) => str.toUpperCase();
  String lowercase(String str) => str.toLowerCase();
  String format(DateTime date) => formatter.format(date);
}