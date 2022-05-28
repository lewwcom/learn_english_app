import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/learn/widget/deck_learn_list_item.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:learn_english_app/widgets/header/header_learn.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:learn_english_app/widgets/search_results.dart';
import 'package:provider/provider.dart';

class LearnDecksPage extends StatelessWidget {
  static const String _title = "Learning Today";

  final List<Deck> decks;

  const LearnDecksPage(this.decks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => SearchNotifier<Deck>(
          (query) => Future.value(
            query.isEmpty
                ? decks
                : decks
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
                title: _title,
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
