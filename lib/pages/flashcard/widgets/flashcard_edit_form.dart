import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/definition.dart';
import 'package:learn_english_app/pages/flashcard/flashcard_page.dart';
import 'package:learn_english_app/theme_data.dart';
import 'package:provider/provider.dart';

class FlashcardEditForm extends StatelessWidget {
  final Definition _definition;

  const FlashcardEditForm(this._definition, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Definition formData = context.read<Definition>();
    final TextStyle? titleStyle = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(fontWeight: FontWeight.bold);
    final borderedInputField = inputDecoration.copyWith(
      border: inputDecoration.border?.copyWith(borderSide: const BorderSide()),
    );
    return SliverToBoxAdapter(
      child: Form(
        key: context.read<GlobalKey<FormState>>(),
        onChanged: () => context
            .read<ValueNotifier<FlashcardPageState>>()
            .value = FlashcardPageState.dirty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Definition", style: titleStyle),
            const SizedBox(height: kPadding),
            TextFormField(
              initialValue: _definition.lexicalCategory,
              onSaved: (value) => formData.lexicalCategory =
                  value ?? _definition.lexicalCategory,
              decoration:
                  borderedInputField.copyWith(labelText: "Lexical Category"),
            ),
            const SizedBox(height: kPadding),
            TextFormField(
              initialValue: _definition.meaning,
              onSaved: (value) =>
                  formData.meaning = value ?? _definition.meaning,
              decoration: borderedInputField.copyWith(labelText: "Definition"),
            ),
            const SizedBox(height: kPadding * 1.5),
            Text("Example", style: titleStyle),
            const SizedBox(height: kPadding),
            TextFormField(
              initialValue: _definition.example,
              onSaved: (value) => formData.example = value,
              decoration: borderedInputField,
            ),
          ],
        ),
      ),
    );
  }
}
