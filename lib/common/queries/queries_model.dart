part of queries;

class Query extends Delegate with ListItem, Filters {
  
  static String endpoint_field = "http://gradesystem.io/onto/query.owl#endpoint";
  static String datasets_field="http://gradesystem.io/onto/query.owl#datasets";
  static String name_field = "http://gradesystem.io/onto/query.owl#name";  
  static String note_field= "http://gradesystem.io/onto/query.owl#note";
  static String target_field="http://gradesystem.io/onto/query.owl#target";
  static String expression_field="http://gradesystem.io/onto/query.owl#expression";
  static String parameters_field="http://gradesystem.io/onto/query.owl#parameters";
  static String predefined_field="http://gradesystem.io/onto/query.owl#predefined";
  
  static final RegExp regexp = new RegExp(r"!(\w+)");
 
  
  final String repo_path;

  Query(this.repo_path, Map bean) : super(bean);
  
  
  
  bool get predefined => get(predefined_field);
  
  
  
  //calculates endpoint
  String get endpoint  {
    
    String endpoint = '../service/${repo_path}/query/${bean[name_field]}/results';
  
    List<String> parameters = this.parameters;
    
    if (!parameters.isEmpty) {
      
      endpoint = "${endpoint}?";
    
      for (String param in parameters)
        endpoint = endpoint.endsWith("?")?"${endpoint}${param}=...":"${endpoint}&${param}=..."; 
    
   }
    
    return endpoint;
  }
  
  
  
  
  List<String> get parameters {
  
     List<String> params = [];
     
     String exp = bean[Query.expression_field];
     
     for (Match m in regexp.allMatches(exp))
       params.add(m.group(1));
     
     return params;
     
  
   }
}

abstract class Queries extends ListItems<Query> {
}

