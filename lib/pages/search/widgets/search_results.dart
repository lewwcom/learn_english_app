import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/search/widgets/search_history.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Word> results = context
        .watch<SearchNotifier>()
        .results
        .map((word) => Word.fromString(word))
        .toList();
    if (results.isEmpty) {
      return _EmptyResult(context.read<SearchNotifier>().query);
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: kPadding / 4),
          child: _SearchResultItem(
            results[index].word,
            results[index].defintions.first.meaning,
          ),
        ),
        childCount: results.length,
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  final String _query;

  const _EmptyResult(this._query, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Sorry, your search \""),
              TextSpan(
                  text: _query,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: "\" did not match any words we known :("),
            ],
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ),
      );
}

class _SearchResultItem extends StatelessWidget {
  final String _word;
  final String _meaning;

  const _SearchResultItem(this._word, this._meaning, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          context.read<SearchHistoryNotifier>().add(_word);
          context.push("/word/" + _word);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(kPadding),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    _word,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _meaning,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class SearchNotifier extends ChangeNotifier {
  // TODO: remove it
  static const List<String> _words = [
    "hello",
    "goodbye",
    "flutter",
    "code",
    "developer",
    "visual",
    "studio"
  ];

  String _query = "";
  List<String> _results = List.empty();
  CancelableOperation? _cancelableOperation;

  SearchNotifier(this._query);

  List<String> get results => List.unmodifiable(_results);

  String get query => _query;

  /// Results will be fetched 500ms after [query] is setted.
  ///
  /// If [query] is setted within 500ms after last set, the currently results
  /// fetching process will be canceled.
  set query(String query) {
    _query = query;
    _fetchResults();
    notifyListeners();
  }

  void _fetchResults() {
    _cancelableOperation?.cancel();
    _cancelableOperation = CancelableOperation.fromFuture(
      Future.delayed(
        const Duration(milliseconds: 500),
        () => Future.delayed(
          const Duration(milliseconds: 200),
          () {
            _results = _words.where((word) => word.contains(_query)).toList();
            notifyListeners();
          },
        ),
      ),
    );
  }
}
