import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

class WordListEntry extends StatelessWidget {
  final String _word;
  final String _meaning;

  const WordListEntry(this._word, this._meaning, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(kPadding),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  _word,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _meaning,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
      );
}
