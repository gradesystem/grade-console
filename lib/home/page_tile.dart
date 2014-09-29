part of home;

@CustomTag("page-tile")
class PageTile extends PolymerElement {

  @published String name;

  PageTile.created() : super.created();

  void onLinkClick(Event e, var details, Node target) {
    dispatchEvent(new CustomEvent("tile-selected", detail:this));
  }

}
