library resizable;

import 'package:polymer/polymer.dart';
import 'dart:html';
import 'dart:async';

class ResizerPolymerElement extends PolymerElement {

  CoreResizer resizer;

  ResizerPolymerElement.created() : super.created() {
    resizer = new CoreResizer(this);
  }

  void attached() {
    super.attached();
    resizer.resizerAttachedHandler();
  }

  void detached() {
    super.detached();
    resizer.resizerDetachedHandler();
  }
  
  addResizeListener(EventListener listener) {
    resizer.addResizeListener(listener);
  }
}

class CoreResizable {

  PolymerElement element;

  StreamSubscription _resizeSubscription;

  CoreResizable(this.element) {
    /*this.element.addEventListener("core-resize", (CustomEvent e){
      if (e.detail == element) print('$element: received event core-resize target: ${e.target} detail: ${e.detail}');
      else print('skipping event core-resize detail: ${e.detail} ');
      });*/
  }
  
  addResizeListener(EventListener listener) {
    this.element.addEventListener("core-resize", (CustomEvent e){
      if (e.detail == element) listener(e);
    });
  }

  /**
   * User must call from `attached` callback
   *
   * @method resizableAttachedHandler
   */
  resizableAttachedHandler([cb]) {
    cb = cb == null ? _notifyResizeSelf : cb;
    element.async((_) {
      var detail = {
        "callback": cb,
        "hasParentResizer": false
      };
      element.fire('core-request-resize', detail: detail);
      if (!detail["hasParentResizer"]) {
        var _boundWindowResizeHandler = cb;
        // log('adding window resize handler', null, this);
        _resizeSubscription = window.onResize.listen((_) => _boundWindowResizeHandler);
      }
    });
  }

  /**
   * User must call from `detached` callback
   *
   * @method resizableDetachedHandler
   */
  resizableDetachedHandler() {
    element.fire('core-request-resize-cancel', onNode: element, canBubble: false);
    if (_resizeSubscription != null) {
      _resizeSubscription.cancel();
      _resizeSubscription = null;
    }
  }

  // Private: fire non-bubbling resize event to self; returns whether
  // preventDefault was called, indicating that children should not
  // be resized
  _notifyResizeSelf(_) {
    return element.fire('core-resize', detail: element, onNode: element, canBubble: false).defaultPrevented;
  }
}

class CoreResizer extends CoreResizable {

  var _boundResizeRequested;
  var _resizerListener;
  List resizeRequestors = [];
  var filter;

  CoreResizer(PolymerElement element, [this.filter]) : super(element);

  /**
    * User must call from `attached` callback
    *
    * @method resizerAttachedHandler
    */
  resizerAttachedHandler() {
    resizableAttachedHandler(this.notifyResize);
    this._boundResizeRequested = this._boundResizeRequested != null ? _boundResizeRequested : this._handleResizeRequested;
    element.addEventListener('core-request-resize', this._boundResizeRequested);
    this._resizerListener = element;
  }

  /**
    * User must call from `detached` callback
    *
    * @method resizerDetachedHandler
    */
  resizerDetachedHandler() {
    this.resizableDetachedHandler();
    this._resizerListener.removeEventListener('core-request-resize', this._boundResizeRequested);
  }

  /**
    * User should call when resizing or un-hiding children
    *
    * @method notifyResize
    */
  notifyResize([target]) {
    //print('$element: notifyResize target: $target resizeRequestors: $resizeRequestorsTarget');

    // Notify self
    if (!this._notifyResizeSelf(null)) {

      //target make sense only if reference a children
      if (target == element) target = null;

      // Notify requestors if default was not prevented
      resizeRequestors
        .where((requestor)=>filter==null || filter(requestor["target"]))
        .forEach((requestor) {

          if ((target != null && target == requestor["target"]) || target == null) {
            //print('$element: notifying requestor ${requestor["target"]}');
            requestor["callback"](requestor["target"]);
          }

      });
    }
  }
  
  List<String> get resizeRequestorsTarget => resizeRequestors.map((requestor)=> requestor["target"]).toList();


  /**
    * Set to `true` if the resizer is actually a peer to the elements it
    * resizes (e.g. splitter); in this case it will listen for resize requests
    * events from its peers on its parent.
    *
    * @property resizerIsPeer
    * @type Boolean
    * @default false
    */

  // Private: Handle requests for resize
  _handleResizeRequested(e) {
    var target = e.path[0];
    if ((target == this) || (target == this._resizerListener)) {
      return;
    }
    
    //print('$element registering resizable $target ${e.detail}');

    this.resizeRequestors.add({
      "target": target,
      "callback": e.detail["callback"]
    });
    target.addEventListener('core-request-resize-cancel', _cancelResizeRequested);
    e.detail["hasParentResizer"] = true;
    e.stopPropagation();
  }

  // Private: Handle cancellation requests for resize
  _cancelResizeRequested(e) {
    // Exit early if we're already out of the DOM (resizeRequestors will already be null)
    resizeRequestors.removeWhere((requestor) => requestor["target"] == e.target);


  }

}
