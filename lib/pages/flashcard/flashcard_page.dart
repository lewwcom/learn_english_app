import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/definition.dart' as definition_model;
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/widgets/definition/definition.dart';
import 'package:learn_english_app/pages/flashcard/widgets/header_content.dart';
import 'package:learn_english_app/pages/flashcard/widgets/flashcard_edit_form.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:provider/provider.dart';

class DeckAndWord {
  final Deck deck;
  final Word word;
  final definition_model.Definition definition;

  DeckAndWord(this.deck, this.word, this.definition);
}

enum FlashcardPageState { viewing, clean, dirty }

class FlashcardPage extends StatelessWidget {
  final Deck _deck;
  final Word _word;
  final definition_model.Definition _definition;

  FlashcardPage(DeckAndWord deckAndWord, {Key? key})
      : _deck = deckAndWord.deck,
        _word = deckAndWord.word,
        _definition = deckAndWord.definition,
        super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                ValueNotifier<FlashcardPageState>(FlashcardPageState.viewing),
          ),
          Provider(
            create: (context) => definition_model.Definition(
              _definition.id,
              _definition.lexicalCategory,
              _definition.meaning,
              _definition.example,
            ),
          ),
          Provider(
            create: (context) => GlobalKey<FormState>(),
          )
        ],
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              Header(HeaderContent(_deck, _word)),
              SliverPadding(
                padding: const EdgeInsets.all(kPadding),
                sliver: _isViewing(context
                        .watch<ValueNotifier<FlashcardPageState>>()
                        .value)
                    ? Definition(
                        _word,
                        _definition,
                        showAddToDeckButton: false,
                      )
                    : FlashcardEditForm(_definition),
              )
            ],
          ),
        ),
      );

  bool _isViewing(FlashcardPageState state) =>
      Enum.compareByName(state, FlashcardPageState.viewing) == 0;
}
