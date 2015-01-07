part of prod;

@CustomTag("prod-page") 
class ProdPage extends PolymerElement {
  
  ProdPage.created() : super.created();
  
  void domReady() {
    fire("area-ready");
  }
}
