import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/pages/learn/widget/deck_learn_list_item.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/header/header_learn.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:provider/provider.dart';

class LearnDecksPage extends StatefulWidget {
  static const String _title = "Learning Today";

  final List<Deck> decks;

  const LearnDecksPage(this.decks, {Key? key}) : super(key: key);

  @override
  State<LearnDecksPage> createState() => _LearnDecksPageState();
}

class _LearnDecksPageState extends State<LearnDecksPage> {
  late List<Deck> decks;
  @override
  void initState() {
    List<Deck> tempDeck = widget.decks;
    for (int i = 0; i < tempDeck.length; ++i) {
      for (int j = i + 1; j < tempDeck.length; ++j) {
        if (tempDeck[i].flashcards.length < tempDeck[j].flashcards.length) {
          Deck tmp = tempDeck[i];
          tempDeck[i] = tempDeck[j];
          tempDeck[j] = tmp;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => SearchNotifier<Deck>(
          (query) => Future.value(
            query.isEmpty
                ? widget.decks
                : widget.decks
                    .where((deck) =>
                        deck.name.toLowerCase().contains(query.toLowerCase()))
                    .toList(),
          ),
          query: "",
        ),
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              const Header(HeaderLearn<Deck>(
                title: LearnDecksPage._title,
              )),
              SliverPadding(
                  padding: const EdgeInsets.all(kPadding),
                  sliver: SearchResults<Deck>(
                    query: context.select((SearchNotifier<Deck> s) => s.query),
                    results:
                        context.select((SearchNotifier<Deck> s) => s.results),
                    childBuilder: (context, results, index) =>
                        DeckLearnListItem(results[index]),
                  ))
            ],
          ),
        ),
      );
}
