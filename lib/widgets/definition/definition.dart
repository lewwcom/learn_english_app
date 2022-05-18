import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/models/definition.dart' as definition_model;
import 'package:learn_english_app/widgets/definition/add_to_deck_button.dart';

class Definition extends StatelessWidget {
  final Word _word;
  final definition_model.Definition _definition;
  final bool _showAddToDeckButton;

  const Definition(this._word, this._definition,
      {Key? key, bool showAddToDeckButton = true})
      : _showAddToDeckButton = showAddToDeckButton,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.bold);
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          Row(
            children: [
              Text("Definition", style: titleStyle),
              if (_showAddToDeckButton) ...[
                const SizedBox(width: kPadding / 2),
                AddToDeckButton(_word, _definition)
              ]
            ],
          ),
          const SizedBox(height: kPadding / 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: _definition.lexicalCategory + " ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ..._definition.meaning
                    .split(" ")
                    .map((word) => _ClickToSeachWord(word, context))
              ],
            ),
          ),
          if (_definition.example != null) ...[
            const SizedBox(height: kPadding),
            Text("Example", style: titleStyle),
            const SizedBox(height: kPadding / 2),
            Text.rich(
              TextSpan(
                children: _definition.example!
                    .split(" ")
                    .map(
                      (word) => _ClickToSeachWord(
                        word,
                        context,
                        style: _isWordOfPage(word)
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          if (_word.imgUrl != null) ...[
            const SizedBox(height: kPadding),
            Text("Image", style: titleStyle),
            const SizedBox(height: kPadding / 2),
            _Image(_word.imgUrl!)
          ],
        ],
      ),
    );
  }

  bool _isWordOfPage(String word) {
    String? cleanForm = _cleanFormOf(word);
    return cleanForm != null &&
        cleanForm.compareTo(_word.word.toLowerCase()) == 0;
  }
}

class _Image extends StatelessWidget {
  final String _imageUrl;

  const _Image(this._imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        color: Colors.black12,
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: constraints.maxWidth * 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kRadius),
              child: CachedNetworkImage(imageUrl: _imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      );
}

class _ClickToSeachWord extends TextSpan {
  _ClickToSeachWord(String word, BuildContext context, {TextStyle? style})
      : super(
          text: word.trim() + " ",
          recognizer: _cleanFormOf(word) != null
              ? (TapGestureRecognizer()
                ..onTap = () => context.push("/words/${_cleanFormOf(word)}"))
              : null,
          style: style,
        );
}

String? _cleanFormOf(String word) =>
    RegExp("\\w+").firstMatch(word.trim().toLowerCase())?[0];
