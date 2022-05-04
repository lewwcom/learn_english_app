import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

typedef SearchResultsChildBuilder<T> = Widget Function(
  BuildContext context,
  List<T> results,
  int index,
);

class SearchResults<T> extends StatelessWidget {
  final String? _query;
  final List<T> _results;
  final SearchResultsChildBuilder<T> _childBuilder;
  final double _spaceBetweenItem;

  const SearchResults({
    Key? key,
    String? query,
    required List<T> results,
    required SearchResultsChildBuilder<T> childBuilder,
    double spaceBetweenItem = kPadding,
  })  : _query = query,
        _results = results,
        _childBuilder = childBuilder,
        _spaceBetweenItem = spaceBetweenItem,
        super(key: key);

  @override
  Widget build(BuildContext context) => _results.isEmpty
      ? _EmptyResult(_query)
      : SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: _spaceBetweenItem / 2),
              child: _childBuilder(context, _results, index),
            ),
            childCount: _results.length,
          ),
        );
}

class _EmptyResult extends StatelessWidget {
  final String? _query;

  const _EmptyResult(this._query, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Sorry, your search"),
              TextSpan(
                  text: _query != null ? " \"" + _query! + "\"" : "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: " did not match anything we known :("),
            ],
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ),
      );
}
