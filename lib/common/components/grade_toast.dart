import 'dart:html';

import 'package:event_bus/event_bus.dart';
import '../../common.dart';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_action_dialog.dart';

@CustomTag("grade-toast")
class GradeToast extends PolymerElement with Dependencies {
  
  @observable
  String text;
  
  @observable
  String role;
  
  @observable
  bool opened;
  
  @observable
  Function callback;
  
  @observable
  GradeError error;
  
  @observable
  bool errorDialogOpen = false;
  
  PaperActionDialog dialog;

  GradeToast.created() : super.created()
  {
    EventBus bus = instanceOf(EventBus);
    bus.on(ToastMessage).listen(onToastMessage);
  }
  
  void ready() {
    dialog = ($['errorDialog'] as Element).shadowRoot.querySelector("paper-action-dialog") as PaperActionDialog;
  }
  
  void onLevelUp() {
    dialog.jsElement.callMethod("updateTargetDimensions");
  }
  
  void onToastMessage(ToastMessage message) {
    
    text = message.message;
    role = message.type;
    callback = message.callback;
    error = message.error;
    
    opened = true;
  }
  
  void onRetry() {
   Function.apply(callback, []);
  }
  
  void onDetails() {
    errorDialogOpen = true;
  }
  
}
