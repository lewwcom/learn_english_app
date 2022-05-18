import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/deck/decks_page.dart';
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';

class AddToDeckButton extends StatelessWidget {
  final Word _word;
  final Definition _definition;

  const AddToDeckButton(this._word, this._definition, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1.8,
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                height: 24,
                child: ElevatedButton.icon(
                  onPressed: () => _askWhichDeckToAdd(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Icon(Icons.list, size: 16),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ),
            )
          ],
        ),
      );

  Future<void> _askWhichDeckToAdd(BuildContext context) async {
    List<Deck> decks = DecksPage.decks;

    await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Choose Deck to add"),
        children: decks
            .map(
              (deck) => SimpleDialogOption(
                child: Text(
                  deck.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onPressed: () => context.push(
                    "/decks/${deck.name}/cards/${_word.word}",
                    extra: DeckAndWord(deck, _word, _definition)),
              ),
            )
            .toList(),
      ),
    );
  }
}
