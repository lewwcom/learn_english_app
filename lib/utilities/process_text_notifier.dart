import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProcessTextNotifier extends ChangeNotifier {
  static const _platform = MethodChannel("app.channel.process.text");
  String _processText = "";
  bool _startedByProcessTextIntent = false;

  ProcessTextNotifier() {
    WidgetsFlutterBinding.ensureInitialized();
    _getProcessText();
  }

  void _getProcessText() async {
    String? processText = await _platform.invokeMethod("getProcessText");
    if (processText != null) {
      _processText = processText;
      _startedByProcessTextIntent = true;
      notifyListeners();
    }
  }

  String get processText => _processText;

  bool get isStartedByProcessTextIntent => _startedByProcessTextIntent;
}
