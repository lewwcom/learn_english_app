import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/definition.dart' as definition_model;
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/widgets/definition/definition.dart';
import 'package:learn_english_app/pages/flashcard/widgets/header_content.dart';
import 'package:learn_english_app/pages/flashcard/widgets/flashcard_edit_form.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:provider/provider.dart';

enum FlashcardPageState { viewing, clean, dirty }

class FlashcardPage extends StatelessWidget {
  final Deck _deck;
  final Flashcard _flashcard;

  const FlashcardPage(this._deck, this._flashcard, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                ValueNotifier<FlashcardPageState>(FlashcardPageState.viewing),
          ),
          Provider(
            create: (context) => definition_model.Definition(
              _flashcard.definition.lexicalCategory,
              _flashcard.definition.meaning,
              _flashcard.definition.example,
            ),
          ),
          Provider(
            create: (context) => GlobalKey<FormState>(),
          )
        ],
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              Header(HeaderContent(_deck, _flashcard)),
              SliverPadding(
                padding: const EdgeInsets.all(kPadding),
                sliver:
                    context.watch<ValueNotifier<FlashcardPageState>>().value ==
                            FlashcardPageState.viewing
                        ? Definition(
                            _flashcard.word,
                            context.watch<definition_model.Definition>(),
                            showAddToDeckButton: false,
                          )
                        : FlashcardEditForm(_flashcard.definition),
              )
            ],
          ),
        ),
      );
}
