part of queries;

class Query extends Delegate with ListItem {
  
  static String endpoint_field = "http://gradesystem.io/onto/query.owl#endpoint";
  static String name_field = "http://gradesystem.io/onto/query.owl#name";  
  static String note_field= "http://gradesystem.io/onto/query.owl#note";
  static String target_field="http://gradesystem.io/onto/query.owl#target";
  static String expression_field="http://gradesystem.io/onto/query.owl#expression";
  static String predefined_field="http://gradesystem.io/onto/query.owl#predefined";
   
    
  Query(this.repo_path, Map bean) : super(bean);
   
  final String repo_path;

  String get name => this.get(name_field);
    
  String get endpoint => '../service/${repo_path}/query/${bean[name_field]}/results';
  
  bool get predefined => get(predefined_field);
}

abstract class Queries extends ListItems<Query> {
}

