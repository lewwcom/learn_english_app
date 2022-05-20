import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/deck.dart';
import 'package:learn_english_app/services/api_deck.dart' as api_deck;
import 'package:learn_english_app/theme_data.dart';
import 'package:learn_english_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class NewDeckPage extends StatelessWidget {
  const NewDeckPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ValueNotifier(""),
        builder: (context, child) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(kPadding * 1.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What is your\nnew deck name?",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: kPadding),
                TextField(
                  onChanged: (value) =>
                      context.read<ValueNotifier<String>>().value = value,
                  decoration: inputDecoration.copyWith(
                    border: inputDecoration.border
                        ?.copyWith(borderSide: const BorderSide()),
                    hintText: "Awesome Name",
                  ),
                ),
                const SizedBox(height: kPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: kPadding / 2),
                    LoadingButton<Deck>(
                      "Create",
                      onPressed: () async => api_deck
                          .create(context.read<ValueNotifier<String>>().value),
                      onDone: (result) async =>
                          context.go("/decks/deck", extra: result),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
