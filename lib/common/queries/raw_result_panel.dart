part of queries;

@CustomTag("raw-result-panel")
class RawResultPanel extends PolymerElement {

  @published
  Result result;
  
  @observable
  int formatTab = 0;
  
  @observable
  bool isactive;
  
  List<RawFormat> formats = RawFormat.values;
    
  RawResultPanel.created() : super.created();
  
  void attributeChanged(name, oldValue, newValue) {
     super.attributeChanged(name, oldValue, newValue);
     if (name == "active") isactive = attributes.containsKey('active');
   }
  
  @ComputedProperty("formats[formatTab]")
  RawFormat get format => formats[formatTab];
  
  @ComputedProperty("result.raws[format]")
  String get raw => result!=null && result.raws[format]!=null?result.raws[format]:"";
  set raw(String drop) {}
  
  @ComputedProperty("format")
  String get mode => format!=null?format.mode:RawFormat.JSON.mode;
  
  @ObserveProperty("result.value format")
  void loadRaw() {
    if (result!=null && format != null && result.hasValue && result.raws[format] == null) asyncFire('load-raw', detail:format);
  }
  
  @ObserveProperty("result.loading result.loadingRaw")
  void refreshEditor() {
    new Future(() { notifyPropertyChange(#isactive, null, true);});
  }
  

}
