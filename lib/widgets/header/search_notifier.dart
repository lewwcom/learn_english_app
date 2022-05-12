import 'package:async/async.dart';
import 'package:flutter/material.dart';

class SearchNotifier<T> extends ChangeNotifier {
  final Future<List<T>> Function(String query) _fetchResult;
  String _query = "";
  List<T> _results = List.empty();
  CancelableOperation<List<T>>? _cancelableOperation;
  bool _isLoading = false;
  Object? _error;

  /// Passing [query] will make instance fetches result at contruction time.
  SearchNotifier(this._fetchResult, {String? query}) {
    if (query != null) {
      _query = query;
      _fetchAfterDelay(Duration.zero);
    }
  }

  List<T> get results {
    if (_error != null) {
      throw _error!;
    }
    return List.unmodifiable(_results);
  }

  String get query => _query;

  /// Results will be fetched 500ms after [query] is setted.
  ///
  /// If [query] is setted within 500ms after last set, the currently results
  /// fetching process will be canceled.
  set query(String query) {
    _query = query;
    _fetchAfterDelay(const Duration(milliseconds: 500));
    // notifyListeners();
  }

  bool get isLoading => _isLoading;

  void _fetchAfterDelay(Duration duration) {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(
      Future.delayed(
        duration,
        () async {
          _isLoading = true;
          notifyListeners();
          return await _fetchResult(_query);
        },
      ),
    ).then((result) {
      _results = result;
      _isLoading = false;
      _error = null;
      notifyListeners();
      return result;
    }, onError: (error, stackTrace) {
      _error = error;
      _isLoading = false;
      notifyListeners();
      return _results;
    });
  }
}
