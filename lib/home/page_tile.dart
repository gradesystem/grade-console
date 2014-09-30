part of home;

@CustomTag("page-tile")
class PageTile extends PolymerElement {

  @published String name;
  
  PageTile.created() : super.created();

  void tileSelected() {
    this.fire("tile-selected", detail:name);
  }

}
