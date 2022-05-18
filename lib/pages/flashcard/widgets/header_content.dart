import 'package:flutter/material.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/services/api_flashcard.dart' as api_flashcard;
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:provider/provider.dart';

class HeaderContent extends StatelessWidget {
  final Word _word;
  final Deck _deck;

  const HeaderContent(this._deck, this._word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlashcardPageState pageState =
        context.watch<ValueNotifier<FlashcardPageState>>().value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _word.word,
              style: Theme.of(context)
                  .primaryTextTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              "from ${_deck.name}",
              style: Theme.of(context).primaryTextTheme.titleLarge?.copyWith(
                  color: Colors.white70, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _getOnPressed(context, pageState),
          child: Text(
            _isViewing(pageState) ? "Edit" : "Save",
            style: Theme.of(context)
                .primaryTextTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary),
        ),
      ],
    );
  }

  bool _isViewing(FlashcardPageState pageState) =>
      Enum.compareByName(pageState, FlashcardPageState.viewing) == 0;

  void Function()? _getOnPressed(
      BuildContext context, FlashcardPageState pageState) {
    switch (pageState) {
      case FlashcardPageState.viewing:
        return () => context.read<ValueNotifier<FlashcardPageState>>().value =
            FlashcardPageState.clean;
      // TODO: implement save action
      case FlashcardPageState.dirty:
        return () {
          context.read<GlobalKey<FormState>>().currentState?.save();
          api_flashcard.create(_deck, context.read<Definition>());
        };
      default:
        return null;
    }
  }
}
