import 'package:polymer/polymer.dart';

@CustomTag('page-menu')
class PageMenu extends PolymerElement {
  
  @published
  String mainlabel = "DATASETS";
  
  PageMenu.created() : super.created();
  
  void onTap(event, detail, target) {
    this.fire("menu-item-selected", detail:target.id);
  }
  
}
