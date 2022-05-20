import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/pages/deck/widget/header_content.dart';
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:learn_english_app/widgets/word_list_entry.dart';
import 'package:provider/provider.dart';

class FlashcardsPage extends StatelessWidget {
  final Deck _deck;
  final String? _searchQuery;

  /// If [searchQuery] is not null, search box will be autofocused only.
  const FlashcardsPage(this._deck, {Key? key, String? searchQuery})
      : _searchQuery = searchQuery,
        super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => SearchNotifier<Flashcard>(
          (query) => Future.value(
            query.isEmpty
                ? _deck.flashcards
                : _deck.flashcards
                    .where((card) => card.word.word
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList(),
          ),
          query: "",
        ),
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              Header(
                HeaderContent(
                  _deck,
                  searchBoxAutoFocus: _searchQuery != null,
                ),
                bottomHeight: kToolbarHeight * 4.3,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kPadding),
                sliver: SearchResults<Flashcard>(
                  query:
                      context.select((SearchNotifier<Flashcard> s) => s.query),
                  results: context
                      .select((SearchNotifier<Flashcard> s) => s.results),
                  childBuilder: (context, results, index) => GestureDetector(
                    onTap: () => context.push(
                        "/decks/${_deck.name}/cards/${results[index].id}",
                        extra: DeckAndFlashcard(_deck, results[index])),
                    child: WordListEntry(
                      results[index].word.word,
                      results[index].definition.meaning,
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
