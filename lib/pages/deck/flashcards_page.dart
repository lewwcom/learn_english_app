import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/pages/deck/widget/header_content.dart';
import 'package:learn_english_app/pages/loading/error_page.dart';
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
  Widget build(BuildContext context) => _deck.flashcards.isEmpty
      ? ErrorPage(
          displayText: "Wow,\nsuch empty!",
          contentText: "Add cards to begin.",
          buttonText: "Add card",
          onPressed: () => context.push("/search"),
          leftAligned: true,
        )
      : MultiProvider(
          providers: [
            Provider.value(value: _deck),
            ChangeNotifierProxyProvider<Deck, SearchNotifier<Flashcard>>(
              create: (context) => SearchNotifier<Flashcard>(
                (query) => _fetchResult(query, context.read<Deck>().flashcards),
                query: "",
              ),
              update: (context, deck, oldNotifier) => SearchNotifier<Flashcard>(
                (query) => _fetchResult(query, deck.flashcards),
                query: "",
              ),
            )
          ],
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
                    query: context
                        .select((SearchNotifier<Flashcard> s) => s.query),
                    results: context
                        .select((SearchNotifier<Flashcard> s) => s.results),
                    childBuilder: (context, results, index) => GestureDetector(
                      onTap: () => context
                          // .push("/decks/${_deck.id}/cards/${results[index].id}"),
                          .push("/decks/${_deck.id}/${results[index].id}"),
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

  Future<List<Flashcard>> _fetchResult(query, List<Flashcard> flashcards) =>
      Future.value(
        query.isEmpty
            ? flashcards
            : flashcards
                .where((card) =>
                    card.word.word.toLowerCase().contains(query.toLowerCase()))
                .toList(),
      );
}
