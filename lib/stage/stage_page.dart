part of stage;

@CustomTag("stage-page") 
class StagePage extends PolymerElement {

  StagePage.created() : super.created();
  
  void domReady() {
    fire("area-ready");
  }
}
