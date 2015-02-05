part of stage;

@CustomTag("stage-page") 
class StagePage extends ResizerPolymerElement {

  StagePage.created() : super.created();
  
  void domReady() {
    fire("area-ready");
  }
}
