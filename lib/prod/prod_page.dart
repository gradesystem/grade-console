part of prod;

@CustomTag("prod-page") 
class ProdPage extends ResizerPolymerElement {
  
  ProdPage.created() : super.created(){
    addEventListener("core-resize", (_){print('core-resize ProdPage');});
  }

  void domReady() {
    fire("area-ready");
  }
}
