import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_client.dart' as api_client;
import 'package:learn_english_app/api/api_exception.dart';
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
            create: (context) => SearchNotifier<Word>(
              (query) async => query.isEmpty
                  ? List.empty()
                  : await api_client.get(
                      "words/?word=$query", WordsSerializer()),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => SearchHistoryNotifier(List.empty()),
          )
        ],
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              const Header(HeaderSearch<Word>(title: _title)),
              const SliverPadding(
                padding: EdgeInsets.all(kPadding),
                sliver: _MainBody(),
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
        ),
      );
}

class _MainBody extends StatelessWidget {
  const _MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchNotifier<Word> searchNotifier =
        context.watch<SearchNotifier<Word>>();

    if (searchNotifier.query.isEmpty) {
      return const SearchHistory();
    }

    if (searchNotifier.isLoading) {
      return const SliverToBoxAdapter(child: LinearProgressIndicator());
    }

    try {
      return SearchResults<Word>(
        query: searchNotifier.query,
        results: searchNotifier.results,
        childBuilder: (context, results, index) => GestureDetector(
          onTap: () {
            context.read<SearchHistoryNotifier>().add(results[index].word);
            context.push(
              "/words/${results[index].word}",
              extra: results[index],
            );
          },
          child: WordListEntry(
            results[index].word,
            results[index].definitions.first.meaning,
          ),
        ),
        spaceBetweenItem: kPadding / 2,
      );
    } catch (error) {
      return SliverToBoxAdapter(
        child: Text(
          error is ApiException ? "Error: $error" : "Unknown error",
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }
  }
}
