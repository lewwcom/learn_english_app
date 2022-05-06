import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:provider/provider.dart';

class HeaderSearch<T> extends StatelessWidget {
  final String _title;
  final String? _buttonText;
  final void Function()? _onButtonPressed;

  /// Pass [buttonText] and [onButtonPressed] to display button.
  const HeaderSearch({
    Key? key,
    required String title,
    String? buttonText,
    void Function()? onButtonPressed,
  })  : _title = title,
        _buttonText = buttonText,
        _onButtonPressed = onButtonPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TitleAndButton(_title, _buttonText, _onButtonPressed),
          const SizedBox(height: kPadding),
          _SearchBox<T>()
        ],
      );
}

class _TitleAndButton extends StatelessWidget {
  final String _title;
  final String? _buttonText;
  final void Function()? _onButtonPressed;

  const _TitleAndButton(this._title, this._buttonText, this._onButtonPressed,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          _title,
          style: Theme.of(context)
              .primaryTextTheme
              .headlineLarge
              ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (_buttonText != null)
          ElevatedButton(
            onPressed: _onButtonPressed,
            child: Text(
              _buttonText!,
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary),
          ),
      ],
    );
  }
}

class _SearchBox<T> extends StatelessWidget {
  const _SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextField(
        onChanged: (value) => context.read<SearchNotifier<T>?>()?.query = value,
        decoration: InputDecoration(
          fillColor: Theme.of(context).cardColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          hintText: "Search...",
          suffixIcon: const Icon(Icons.search),
        ),
      );
}
