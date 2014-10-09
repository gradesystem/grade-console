import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_progress.dart';

@CustomTag("infinite-progress")
class InfiniteProgress extends PolymerElement {
  
  @published
  bool run;
  
  PaperProgress progress;

  InfiniteProgress.created() : super.created();
  
  void ready() {
    progress = $['progress'];
  }
  
  void runChanged() {
    progress.value = progress.min;
    if (run) {
      nextProgress(0);
    }
  }

  nextProgress(_) {
    if (progress.value < progress.max) {
      progress.value += (progress.step != 0 ? progress.step : 1);
    } else {
      progress.value = progress.min;
    }
    if (run) window.animationFrame.then(nextProgress);
  }
}
