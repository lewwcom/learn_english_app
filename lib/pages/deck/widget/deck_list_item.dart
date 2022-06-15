import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/theme_data.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:learn_english_app/widgets/loading_button.dart';
import 'package:learn_english_app/widgets/word_card/word_card.dart';
import 'package:provider/provider.dart';

class DeckListItem extends StatelessWidget {
  final Deck _deck;

  const DeckListItem(this._deck, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const DrawerMotion(),
          children: [
            _RenameAction(_deck,
                context.read<LoadingNotifier<List<Deck>>>() as DecksNotifier),
            _DeleteAction(_deck,
                context.read<LoadingNotifier<List<Deck>>>() as DecksNotifier),
          ],
        ),
        child: _DeckPresentation(_deck),
      );
}

class _RenameAction extends StatelessWidget {
  final Deck _deck;
  final DecksNotifier _decksNotifier;

  const _RenameAction(this._deck, this._decksNotifier, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SlidableAction(
        backgroundColor: const Color(0x00000000),
        foregroundColor: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.zero,
        icon: Icons.edit,
        onPressed: (context) => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ValueNotifier(""),
            builder: (context, child) => _PopUp(
              title: "Rename \"${_deck.name}\" deck",
              content: TextField(
                onChanged: (value) =>
                    context.read<ValueNotifier<String>>().value = value,
                decoration: inputDecoration.copyWith(
                  border: inputDecoration.border
                      ?.copyWith(borderSide: const BorderSide()),
                  hintText: "New Awesome Name",
                ),
              ),
              acceptText: "Save",
              acceptCallback: () => _decksNotifier.renameDeck(
                _deck.id!,
                context.read<ValueNotifier<String>>().value,
              ),
            ),
          ),
        ),
      );
}

class _DeleteAction extends StatelessWidget {
  final Deck _deck;
  final DecksNotifier _decksNotifier;

  const _DeleteAction(this._deck, this._decksNotifier, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => SlidableAction(
        backgroundColor: const Color(0x00000000),
        foregroundColor: Theme.of(context).colorScheme.error,
        padding: EdgeInsets.zero,
        icon: Icons.delete,
        onPressed: (context) async => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _PopUp(
            title: "Delete ${_deck.name}",
            content: const Text("Are you sure?"),
            acceptText: "Delete",
            acceptCallback: () => _decksNotifier.deleteDeck(_deck.id!),
            isDangerousAction: true,
          ),
        ),
      );
}

class _DeckPresentation extends StatelessWidget {
  final Deck _deck;

  const _DeckPresentation(this._deck, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push("/decks/${_deck.id}"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) => SizedBox(
                height: constraints.maxWidth * 1.7 / 3,
                child: _deck.flashcards.isNotEmpty
                    ? WordCard(
                        _deck.flashcards.first.word.word,
                        _deck.flashcards.first.definition.meaning,
                      )
                    : const WordCard("Empty!", "Add cards to begin"),
              ),
            ),
            const SizedBox(height: kPadding / 2),
            Text(
              _deck.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              "${_deck.flashcards.length} cards",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey),
            )
          ],
        ),
      );
}

class _PopUp extends StatelessWidget {
  final String _title;
  final Widget _content;
  final String _acceptText;
  final bool _isDangerousAction;
  final Future<void> Function() _acceptCallback;

  const _PopUp({
    Key? key,
    required String title,
    required Widget content,
    required String acceptText,
    required Future<void> Function() acceptCallback,
    bool isDangerousAction = false,
  })  : _title = title,
        _content = content,
        _acceptText = acceptText,
        _acceptCallback = acceptCallback,
        _isDangerousAction = isDangerousAction,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? textColor =
        _isDangerousAction ? Theme.of(context).colorScheme.error : null;
    return AlertDialog(
      title: Text(_title, style: TextStyle(color: textColor)),
      content: _content,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(color: textColor ?? Colors.grey),
          ),
          style: textColor != null
              ? OutlinedButton.styleFrom(side: BorderSide(color: textColor))
              : null,
        ),
        LoadingButton<void>(
          _acceptText,
          onPressed: () => _acceptCallback(),
          onDone: (value) async => Navigator.of(context).pop(),
          buttonColor: textColor,
        ),
      ],
    );
  }
}
