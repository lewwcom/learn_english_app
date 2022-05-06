import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/search/widgets/search_history.dart';
import 'package:learn_english_app/pages/search/widgets/search_result_item.dart';
import 'package:learn_english_app/pages/search/widgets/words_of_the_day.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/header/header_search.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const String _title = "Lookup";

  static const List<String> _words = [
    "hello",
    "goodbye",
    "flutter",
    "code",
    "developer",
    "visual",
    "studio"
  ];

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SearchNotifier<String>(
              (query) => Future.value(
                query.isEmpty
                    ? List.empty()
                    : _words
                        .where((word) =>
                            word.toLowerCase().contains(query.toLowerCase()))
                        .toList(),
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => SearchHistoryNotifier(<String>[]),
          )
        ],
        builder: (context, child) {
          String query = context.select((SearchNotifier<String> s) => s.query);
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                const Header(HeaderSearch<String>(title: _title)),
                SliverPadding(
                  padding: const EdgeInsets.all(kPadding),
                  sliver: query.isEmpty
                      ? const SearchHistory()
                      : SearchResults<Word>(
                          query: query,
                          results: context
                              .select((SearchNotifier<String> s) => s.results)
                              .map((word) => Word.fromString(word))
                              .toList(),
                          childBuilder: (context, results, index) =>
                              SearchResultItem(
                            results[index].word,
                            results[index].defintions.first.meaning,
                          ),
                          spaceBetweenItem: kPadding / 2,
                        ),
                ),
                WordsOfTheDay()
              ],
            ),
          );
        },
      );
}
