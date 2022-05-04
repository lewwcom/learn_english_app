import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/decks/widget/deck_list_item.dart';
import 'package:learn_english_app/widgets/header.dart';
import 'package:learn_english_app/widgets/header_search.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:provider/provider.dart';

class DecksPage extends StatelessWidget {
  static const String _title = "Flashcard";

  final List<Deck> _decks = [
    for (String name in ["Tech", "Art", "Science", "Math", "Sport"])
      Deck.fromWordList(name, [Word.fromString("Hello")])
  ];

  DecksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => SearchNotifier<Deck>(
          (query) => Future.value(
            query.isEmpty
                ? _decks
                : _decks
                    .where((deck) =>
                        deck.name.toLowerCase().contains(query.toLowerCase()))
                    .toList(),
          ),
          query: "",
        ),
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              // TODO: New deck button
              const Header(HeaderSearch<Deck>(_title)),
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
}
