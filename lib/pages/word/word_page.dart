import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/word/widgets/header_content.dart';
import 'package:learn_english_app/widgets/definition/definition.dart';
import 'package:learn_english_app/widgets/header/header.dart';
import 'package:provider/provider.dart';

class WordPage extends StatelessWidget {
  final Word _word;

  const WordPage(this._word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ValueNotifier(0),
        builder: (context, child) => Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: Header(HeaderContent(_word)),
              ),
            ],
            body: PageView.builder(
              onPageChanged: (value) =>
                  context.read<ValueNotifier<int>>().value = value,
              itemCount: _word.definitions.length,
              itemBuilder: (context, index) => CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(kPadding),
                    sliver: Definition(_word, _word.definitions[index]),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
