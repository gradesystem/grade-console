part of prod;

@CustomTag("prod-page") 
class ProdPage extends ResizerPolymerElement {
  
  ProdPage.created() : super.created();

  void domReady() {
    fire("area-ready");
  }
}
