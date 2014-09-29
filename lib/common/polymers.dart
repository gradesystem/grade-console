part of common;

abstract class Polybase extends PolymerElement with Dependencies {
  
  static final Logger _log = new Logger('base-polymer');
  
  static final String model_attr = 'model';
  
  @observable var model;
  
  Polybase.created() : super.created() {
    
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


@CustomTag(ComingSoon.name) 
class ComingSoon extends PolymerElement {
 
  static const name = "coming-soon";
  
  ComingSoon.created() : super.created();
   
}
