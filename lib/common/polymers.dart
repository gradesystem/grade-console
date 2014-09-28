part of common;

abstract class Polybase<M> extends PolymerElement with Dependencies {
  
  static final Logger _log = new Logger('polymer');
  
  static final String model_attr = 'model';
  
  @observable var model;
  
  Polybase.created() : super.created();
  
  attached() {
    
    String modelname = attributes[model_attr];

        
        if (modelname==null)
          _log.warning("missing '$model_attr' attribute on $nodeName");
        else
          this.model = instanceCalled(modelname);
        
  }
  
}