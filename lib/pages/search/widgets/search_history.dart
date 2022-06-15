import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildListDelegate(
          context
              .watch<SearchHistoryNotifier>()
              .history
              .map((word) => TextButton.icon(
                    onPressed: () => context.push("/words/$word"),
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
  static SharedPreferences? _prefs;
  final Set<String> _history = {};

  SearchHistoryNotifier() {
    _init();
  }

  Future<void> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = _prefs ?? await SharedPreferences.getInstance();
    List<String> history =
        _prefs?.getStringList("search_history") ?? List.empty();
    _history.addAll(history);
    notifyListeners();
  }

  void add(String word) {
    _history.remove(word);
    _history.add(word);
    if (_history.length > _max) {
      _history.remove(_history.first);
    }
    _prefs?.setStringList("search_history", _history.toList());
    notifyListeners();
  }

  List<String> get history => List.unmodifiable(_history.toList().reversed);
}
