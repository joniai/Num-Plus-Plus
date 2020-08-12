import 'dart:async';
import 'dart:io';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:num_plus_plus/src/backend/mathmodel.dart';
import 'package:num_plus_plus/src/pages/settingpage.dart';
import 'package:num_plus_plus/src/widgets/mathbox_controller.dart';

class MathBoxWeb extends StatefulWidget {
  @override
  _MathBoxWebState createState() => new _MathBoxWebState();
}

class _MathBoxWebState extends State<MathBoxWeb> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mode = Provider.of<CalculationMode>(context, listen: false);
    final matrixModel = Provider.of<MatrixModel>(context, listen: false);
    final functionModel = Provider.of<FunctionModel>(context, listen: false);
    final mathModel = Provider.of<MathModel>(context, listen: false);
    js.context['latexString'] = (String message) {
      if (mode.value == Mode.Matrix) {
        matrixModel.updateExpression(message);
      } else {
        if (message.contains(RegExp('x|y'))) {
          mode.changeMode(Mode.Function);
          functionModel.updateExpression(message);
        } else {
          mode.changeMode(Mode.Basic);
          mathModel.updateExpression(message);
          mathModel.calcNumber();
        }
      }
    };
    js.context['clearable'] = (String message) {
      mathModel.changeClearable(message == 'false' ? false : true);
    };
    void onPageFinished() {
      final setting = Provider.of<SettingModel>(context, listen: false);
      final mathBoxController =
          Provider.of<MathBoxController>(context, listen: false);
      if (setting.initPage == 1) {
        mathBoxController.addExpression('\\\\bmatrix');
      }
    }

    js.context['document']
        .callMethod("addEventListener", ["DOMContentLoaded", onPageFinished]);
  }

  @override
  Widget build(BuildContext context) {
    html.IFrameElement _element = html.IFrameElement()
      ..style.border = 'none'
      ..src = "http://localhost:8080/assets/html/homepage.html";
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      "iframe-mathbox",
      (int viewId) => _element,
    );
    return HtmlElementView(
      viewType: "iframe-mathbox",
    );
  }
}
