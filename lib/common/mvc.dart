part of common;

abstract class Model {} 

abstract class GradeEntity extends Delegate with Observable {
  
  GradeEntity(Map bean):super(bean);

}

class View extends PolymerElement with Filters,Validators, Dependencies {
  
  View.created() : super.created();
  
  dynamic get(Keyed item,key) => getOrNull(item, key, "???");
  
  dynamic getOrNull(Keyed item,key, [defaultValue]) {
       
          String value = defaultValue;
          
          if (item!=null) {
            
            String current= item.get(key);
            
            value = (current==null || current.isEmpty)? value : current;
            
          }
          
          return value;
     }
  
    List<dynamic> getAll(Keyed item,key) {
        
        if (item!=null) {
          
          List current = item.get(key);
          
          if (current != null) return current;
        }
        
        return [];
   }
    
    Map<dynamic,dynamic> getMap(Keyed item,key) {
         
            Map value = {};
            
            if (item!=null) {
              
              Map current= item.get(key);
              
              value = (current==null || current.isEmpty)? value : current;
              
            }
            
            return value;
       }
  
    void set(Keyed item,key,value) {
     
        if (item!=null)
         item.set(key,value);
       
   }
}
