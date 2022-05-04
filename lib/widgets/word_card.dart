import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

class WordCard extends StatelessWidget {
  final String _word;
  final String _meaning;

  const WordCard(this._word, this._meaning, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(2 * kPadding),
          // To pass right constraint to IntrinsicWidth
          child: Center(
            child: IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _word,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    textAlign: TextAlign.end,
                  ),
                  Text(
                    _meaning,
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
