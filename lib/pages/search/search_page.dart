import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/search/widgets/search_history.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/header/header_search.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:learn_english_app/widgets/word_card/word_cards_row.dart';
import 'package:learn_english_app/widgets/word_list_entry.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const String _title = "Lookup";

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
                              GestureDetector(
                            onTap: () {
                              context
                                  .read<SearchHistoryNotifier>()
                                  .add(results[index].word);
                              context.push("/words/${results[index].word}");
                            },
                            child: WordListEntry(
                              results[index].word,
                              results[index].defintions.first.meaning,
                            ),
                          ),
                          spaceBetweenItem: kPadding / 2,
                        ),
                ),
                WordCardsRow(
                  title: "Words of the day",
                  words: _words
                      .sublist(0, 5)
                      .map((word) => Word.fromString(word))
                      .toList(),
                  onTapWord: (word) {
                    context.read<SearchHistoryNotifier>().add(word.word);
                    context.push("/words/${word.word}");
                  },
                )
              ],
            ),
          );
        },
      );
}
