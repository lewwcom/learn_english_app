import 'package:flutter/material.dart';

class LoadingNotifier<T> extends ChangeNotifier {
  T? _result;
  Object? _error;
  final Future<T> Function() _fetchResult;

  LoadingNotifier(this._fetchResult, {bool fetchOnCreate = true}) {
    if (fetchOnCreate) {
      fetch();
    }
  }

  Future<void> fetch() async {
    try {
      _result = await _fetchResult();
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
