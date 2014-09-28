part of common;

abstract class Polybase<M> extends PolymerElement with Dependencies {
  
  static final Logger _log = new Logger('base-polymer');
  
  static final String model_attr = 'model';
  
  @observable var model;
  
  Polybase.created() : super.created();
  
  attached() {
    
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