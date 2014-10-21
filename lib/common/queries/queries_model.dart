part of queries;

class Query extends Delegate with ListItem {
  
  static String endpoint_field = "http://gradesystem.io/onto/query.owl#endpoint";
  static String name_field = "http://gradesystem.io/onto/query.owl#name";  
  static String note_field= "http://gradesystem.io/onto/query.owl#note";
  static String target_field="http://gradesystem.io/onto/query.owl#target";
  static String expression_field="http://gradesystem.io/onto/query.owl#expression";
   
    
  Query(this.repo_path, Map bean) : super(bean);
   
  final String repo_path;
    
  String get endpoint => '../service/${repo_path}/query/${bean[name_field]}/results';
      
  String get title => this.get(name_field);
  
  String get subTitle =>  this.endpoint;
   
}

abstract class Queries extends ListItems<Query> {
}

