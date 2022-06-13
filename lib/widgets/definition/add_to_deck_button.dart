import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/models/flashcard.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/services/api_deck.dart' as api_deck;
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:provider/provider.dart';

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
                  icon: const Icon(Icons.add, size: kSmallIconSize),
                  label: const Icon(Icons.list, size: kSmallIconSize),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ),
            )
          ],
        ),
      );

  Future<void> _askWhichDeckToAdd(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => _ChooseDeckDialog(_word, _definition),
    );
  }
}

class _ChooseDeckDialog extends StatelessWidget {
  final Word _word;
  final Definition _definition;

  const _ChooseDeckDialog(this._word, this._definition, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LoadingNotifier(() => api_deck.readAll()),
        builder: (context, child) {
          try {
            List<Deck>? decks =
                context.watch<LoadingNotifier<List<Deck>>>().result;
            return SimpleDialog(
              title: const Text("Choose Deck to add"),
              children: decks != null
                  ? decks
                      .map(
                        (deck) => SimpleDialogOption(
                          child: Text(
                            deck.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          onPressed: () => context.go(
                            // "/decks/${deck.id}/cards/newcard",
                            "/decks/${deck.id}/newcard",
                            extra: Flashcard(_word, _definition),
                          ),
                        ),
                      )
                      .toList()
                  : [
                      const SimpleDialogOption(
                        child: LinearProgressIndicator(),
                        padding: EdgeInsets.zero,
                      )
                    ],
            );
          } catch (e) {
            return const _ErrorDialog();
          }
        },
      );
}

class _ErrorDialog extends StatelessWidget {
  const _ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SimpleDialog(
        title: const Text("Choose Deck to add"),
        children: [
          SimpleDialogOption(
            child: Row(
              children: [
                Icon(
                  Icons.error,
                  size: kSmallIconSize,
                  color: Theme.of(context).errorColor,
                ),
                const SizedBox(width: kPadding / 2),
                Text(
                  "Fail to load Decks",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ],
            ),
          ),
        ],
      );
}
