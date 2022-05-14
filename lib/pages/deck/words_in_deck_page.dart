import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/deck/widget/deck_page_header_content.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:learn_english_app/widgets/word_list_entry.dart';
import 'package:provider/provider.dart';

class WordsInDeckPage extends StatelessWidget {
  final Deck _deck;
  final String? _searchQuery;

  const WordsInDeckPage(this._deck, {Key? key, String? searchQuery})
      : _searchQuery = searchQuery,
        super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => SearchNotifier<Word>(
          (query) => Future.value(
            query.isEmpty
                ? _deck.words
                : _deck.words
                    .where((word) =>
                        word.word.toLowerCase().contains(query.toLowerCase()))
                    .toList(),
          ),
          query: "",
        ),
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              Header(
                DeckPageHeaderContent(
                  _deck,
                  searchBoxAutoFocus: _searchQuery != null,
                ),
                bottomHeight: kToolbarHeight * 4.3,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kPadding),
                sliver: SearchResults<Word>(
                  query: context.select((SearchNotifier<Word> s) => s.query),
                  results:
                      context.select((SearchNotifier<Word> s) => s.results),
                  childBuilder: (context, results, index) => GestureDetector(
                    onTap: () => context.push("/words/${results[index].word}"),
                    child: WordListEntry(
                      results[index].word,
                      results[index].defintions.first.meaning,
                    ),
                  ),
                  spaceBetweenItem: kPadding / 2,
                ),
              )
            ],
          ),
        ),
      );
}
