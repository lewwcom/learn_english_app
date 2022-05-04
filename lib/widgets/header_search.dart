import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:provider/provider.dart';

class HeaderSearch<T> extends StatelessWidget {
  final String _title;

  const HeaderSearch(this._title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: kPadding),
          _SearchBox<T>()
        ],
      );
}

class _SearchBox<T> extends StatelessWidget {
  const _SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextField(
        onChanged: (value) => context.read<SearchNotifier<T>?>()?.query = value,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: "Search...",
            suffixIcon: const Icon(Icons.search)),
      );
}

class SearchNotifier<T> extends ChangeNotifier {
  final Future<List<T>> Function(String query) _fetchResult;
  String _query = "";
  List<T> _results = List.empty();
  CancelableOperation? _cancelableOperation;

  /// Passing [query] will make instance fetches result at contruction time.
  SearchNotifier(this._fetchResult, {String? query}) {
    if (query != null) {
      _query = query;
      _fetchAfterDelay(Duration.zero);
    }
  }

  List<T> get results => List.unmodifiable(_results);

  String get query => _query;

  /// Results will be fetched 500ms after [query] is setted.
  ///
  /// If [query] is setted within 500ms after last set, the currently results
  /// fetching process will be canceled.
  set query(String query) {
    _query = query;
    _fetchAfterDelay(const Duration(milliseconds: 500));
    notifyListeners();
  }

  void _fetchAfterDelay(Duration duration) {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(
      Future.delayed(
        duration,
        () async {
          _results = await _fetchResult(_query);
          notifyListeners();
        },
      ),
    );
  }
}
