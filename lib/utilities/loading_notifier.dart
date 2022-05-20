import 'package:flutter/material.dart';

class LoadingNotifier<T> extends ChangeNotifier {
  T? _result;
  Object? _error;

  LoadingNotifier(Future<T> Function() fetchResult) {
    _fetch(fetchResult);
  }

  Future<void> _fetch(Future<T> Function() fetchResult) async {
    try {
      _result = await fetchResult();
    } catch (e, stack) {
      _error = e;
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stack);
    }
    notifyListeners();
  }

  T? get result {
    if (_error != null) {
      throw _error!;
    }
    return _result;
  }
}
