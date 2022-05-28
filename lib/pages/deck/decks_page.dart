import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/pages/deck/widget/deck_list_item.dart';
import 'package:learn_english_app/pages/loading/error_page.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/header/header_search.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:provider/provider.dart';

class DecksPage extends StatelessWidget {
  static const String _title = "Flashcard";

  final List<Deck> _decks;

  const DecksPage(this._decks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => _decks.isEmpty
      ? ErrorPage(
          displayText: "Let's\nget started!",
          contentText: "Create decks to begin.",
          buttonText: "Create deck",
          onPressed: () => context.push("/create-deck"),
          leftAligned: true,
        )
      : MultiProvider(
          providers: [
            Provider.value(value: _decks),
            ChangeNotifierProxyProvider<List<Deck>, SearchNotifier<Deck>>(
              create: (context) => SearchNotifier<Deck>(
                (query) => _fetchResult(query, context.read<List<Deck>>()),
                query: "",
              ),
              update: (context, decks, oldNotifier) => SearchNotifier<Deck>(
                (query) => _fetchResult(query, decks),
                query: "",
              ),
            )
          ],
          builder: (context, child) => Scaffold(
            body: CustomScrollView(
              slivers: [
                Header(HeaderSearch<Deck>(
                  title: _title,
                  buttonText: "New deck",
                  onButtonPressed: () => context.push("/create-deck"),
                )),
                SliverPadding(
                  padding: const EdgeInsets.all(kPadding),
                  sliver: SearchResults<Deck>(
                    query: context.select((SearchNotifier<Deck> s) => s.query),
                    results:
                        context.select((SearchNotifier<Deck> s) => s.results),
                    childBuilder: (context, results, index) =>
                        DeckListItem(results[index]),
                  ),
                ),
              ],
            ),
          ),
        );

  Future<List<Deck>> _fetchResult(query, List<Deck> decks) => Future.value(
        query.isEmpty
            ? decks
            : decks
                .where((deck) =>
                    deck.name.toLowerCase().contains(query.toLowerCase()))
                .toList(),
      );
}
