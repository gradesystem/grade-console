part of queries;

@CustomTag("query-publish") 
class QueryPublish extends View {
  
  QueryKeys K = const QueryKeys();  
    
  @ComputedProperty('item.edit')
  bool get editable => item==null?false:item.edit;
  
  @ComputedProperty('queries.selected')
  EditableQuery get item => queries==null?null:queries.selected;
  
  @published
  Queries queries;
  
  @published
  bool statusEditEnabled;
   
  QueryPublish.created() : super.created();
  
  @ComputedProperty("item.synching")
  bool get loading => item!=null && item.synching;
  
  @ComputedProperty("item.model.bean[K.status]")
  bool get ispublished => get(item,K.status) == K.status_published;
  set ispublished(bool value) {set(item,K.status,value?K.status_published:K.status_unpublished);}
  
  @ComputedProperty("item.model.parameters")
  String get parameters {
    
    String params = '';
    
    if (item!=null) {
      
      List<String> parameters = item.model.parameters;
      params = parameters.isEmpty? params :parameters.toString();
    }
    
    return params;
    
  }
  
}
