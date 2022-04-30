import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';

class Definition extends StatelessWidget {
  final Word _word;
  final int _defIndex;

  const Definition(this._word, this._defIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? bodyStyle = Theme.of(context).textTheme.bodyMedium;
    TextStyle? titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.bold);
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        [
          Text("Definitions", style: titleStyle),
          const SizedBox(height: kPadding / 2),
          Text(_word.defintions[_defIndex].meaning, style: bodyStyle),
          const SizedBox(height: kPadding),
          Text("Examples", style: titleStyle),
          const SizedBox(height: kPadding / 2),
          Text(_word.defintions[_defIndex].example, style: bodyStyle),
          const SizedBox(height: kPadding),
          Text("Image", style: titleStyle),
          const SizedBox(height: kPadding / 2),
          _Image(_word.inclusionImageUrl),
        ],
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final String _imageUrl;

  const _Image(this._imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        // TODO: CardTheme
        margin: EdgeInsets.zero,
        color: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: constraints.maxWidth * 2 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: _imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
}
