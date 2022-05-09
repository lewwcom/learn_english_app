import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildListDelegate(
          context
              .watch<SearchHistoryNotifier>()
              .history
              .map((word) => TextButton.icon(
                    onPressed: () {
                      context.read<SearchHistoryNotifier>().add(word);
                      context.push("/words/$word");
                    },
                    icon: const Icon(
                      Icons.history,
                      color: Colors.grey,
                    ),
                    label: Text(
                      word,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey),
                    ),
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                  ))
              .toList(),
        ),
      );
}

class SearchHistoryNotifier with ChangeNotifier {
  static const int _max = 3;
  final Set<String> _history = {};

  SearchHistoryNotifier(List<String> history) {
    _history.addAll(history.getRange(0, min(history.length, _max)));
  }

  void add(String word) {
    _history.remove(word);
    _history.add(word);
    if (_history.length > _max) {
      _history.remove(_history.first);
    }
    notifyListeners();
  }

  List<String> get history => List.unmodifiable(_history.toList().reversed);
}
