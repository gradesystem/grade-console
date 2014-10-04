part of common;

abstract class Polybase extends PolymerElement with Dependencies, Filters {
  
  static final Logger _log = new Logger('grade.basepolymer');
  
  static final String model_attr = 'model';
  
  @observable var model;
  
  Type _type;
  
  Polybase.created() : this.createWith(null);
  
  Polybase.createWith(Type type) : super.created() {
    
    if (type == null)
    
      _initFromName();
    
    else
      
      try {
      
        this.model = instanceOf(type);
      
      }
      catch(e,s) {
        
        _log.severe("failed dependency lookup",e,s);
      
      }
    
    
  }
  
  _initFromName() {
    
    _type = dynamic;
    
    String modelname = attributes[model_attr];
         
        if (modelname==null)
          _log.warning("missing '$model_attr' attribute on $nodeName");
      
        else
          try {
            this.model = instanceCalled(modelname);
          }
          catch(e,s) {
            _log.severe("failed dependency lookup",e,s);
          }
  }
  
  
  
  
}


@CustomTag("coming-soon") 
class ComingSoon extends PolymerElement {
 
  ComingSoon.created() : super.created();
   
}
