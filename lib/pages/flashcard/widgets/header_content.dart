import 'package:flutter/material.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:learn_english_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class HeaderContent extends StatelessWidget {
  final Flashcard _flashcard;
  final Deck _deck;

  const HeaderContent(this._deck, this._flashcard, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _flashcard.word.word,
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headlineLarge
                      ?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
                Text(
                  "from ${_deck.name}",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .titleLarge
                      ?.copyWith(
                          color: Colors.white70, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ],
            ),
          ),
          Flexible(flex: 3, child: _Button(_flashcard)),
        ],
      );
}

class _Button extends StatelessWidget {
  final Flashcard _flashcard;

  const _Button(this._flashcard, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<FlashcardPageState> pageStateNotifier =
        context.watch<ValueNotifier<FlashcardPageState>>();
    switch (pageStateNotifier.value) {
      case FlashcardPageState.viewing:
        return _StyledElevatedButton(
          "Edit",
          onPressed: () => pageStateNotifier.value = FlashcardPageState.clean,
        );
      case FlashcardPageState.clean:
        return const _StyledElevatedButton("Save");
      case FlashcardPageState.dirty:
        return LoadingButton<void>(
          "Save",
          onPressed: () async {
            context.read<GlobalKey<FormState>>().currentState?.save();
            Flashcard flashcard = Flashcard(
              _flashcard.word,
              context.read<Definition>(),
              id: _flashcard.id,
            );
            await (context.read<LoadingNotifier<Deck>>() as DeckNotifier)
                .replaceCard(flashcard.id!, flashcard);
          },
          onDone: (_) async =>
              pageStateNotifier.value = FlashcardPageState.viewing,
          textStyle: Theme.of(context)
              .primaryTextTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          buttonColor: Theme.of(context).colorScheme.secondary,
        );
    }
  }
}

class _StyledElevatedButton extends StatelessWidget {
  final void Function()? _onPressed;
  final String _buttonText;

  const _StyledElevatedButton(
    this._buttonText, {
    Key? key,
    void Function()? onPressed,
  })  : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: _onPressed,
        child: Text(
          _buttonText,
          style: Theme.of(context)
              .primaryTextTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.secondary),
      );
}
