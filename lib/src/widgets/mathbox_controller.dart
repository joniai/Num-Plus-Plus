import 'package:flutter/material.dart';
import 'dart:js' as js;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';

class MathBoxController {
  WebViewController _webViewController;
  AnimationController clearAnimationController;

  set webViewController(WebViewController controller) {
    this._webViewController = controller;
  }

  void addExpression(String msg, {bool isOperator = false}) {
    if (kIsWeb) {
      var object = js.JsObject(js.context['Object']);
      object['isOperator'] = isOperator;
      js.context.callMethod("addCmd", [msg, object]);
    } else {
      assert(_webViewController != null);
      _webViewController.evaluateJavascript(
          "addCmd('$msg', {isOperator: ${isOperator.toString()}})");
    }
  }

  void addString(String msg) {
    if (kIsWeb) {
      js.context.callMethod("addString", [msg]);
    } else {
      assert(_webViewController != null);
      _webViewController.evaluateJavascript("addString('$msg')");
    }
  }

  void equal() {
    if (kIsWeb) {
      js.context.callMethod("equal");
    } else {
      assert(_webViewController != null);
      _webViewController.evaluateJavascript("equal()");
    }
  }

  void addKey(String key) {
    if (kIsWeb) {
      js.context.callMethod("simulateKey", [key]);
    } else {
      assert(_webViewController != null);
      _webViewController.evaluateJavascript("simulateKey('$key')");
    }
  }

  void deleteExpression() {
    if (kIsWeb) {
      js.context.callMethod("delString");
    } else {
      assert(_webViewController != null);
      _webViewController.evaluateJavascript("delString()");
    }
  }

  void deleteAllExpression() {
    if (kIsWeb) {
      js.context.callMethod("delAll");
    } else {
      assert(_webViewController != null);
      _webViewController.evaluateJavascript("delAll()");
    }
  }
}
