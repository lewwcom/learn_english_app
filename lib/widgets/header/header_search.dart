import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:provider/provider.dart';

class HeaderSearch<T> extends StatelessWidget {
  final String _title;
  final String? _buttonText;
  final void Function()? _onButtonPressed;
  final String? _searchPageLocation;
  final bool _searchBoxAutoFocus;

  /// Pass [buttonText] and [onButtonPressed] to display button. If
  /// [searchPageLocation] is not null, when user taps on search box, app will be
  /// navigated to your search page.
  const HeaderSearch({
    Key? key,
    required String title,
    String? buttonText,
    void Function()? onButtonPressed,
    String? searchPageLocation,
    bool searchBoxAutoFocus = false,
  })  : _title = title,
        _buttonText = buttonText,
        _onButtonPressed = onButtonPressed,
        _searchPageLocation = searchPageLocation,
        _searchBoxAutoFocus = searchBoxAutoFocus,
        super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _TitleAndButton(_title, _buttonText, _onButtonPressed),
          const SizedBox(height: kPadding),
          _SearchBox<T>(_searchPageLocation, _searchBoxAutoFocus)
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
  Widget build(BuildContext context) => Row(
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

class _SearchBox<T> extends StatelessWidget {
  final String? _searchLocation;
  final bool _searchBoxAutoFocus;

  const _SearchBox(this._searchLocation, this._searchBoxAutoFocus, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => TextField(
        autofocus: _searchBoxAutoFocus,
        readOnly: _searchLocation != null,
        onTap: _searchLocation != null
            ? () => context.push("$_searchLocation?query=")
            : null,
        onChanged: (value) => context.read<SearchNotifier<T>?>()?.query = value,
        decoration: InputDecoration(
          fillColor: Theme.of(context).cardColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kRadius),
            borderSide: BorderSide.none,
          ),
          hintText: "Search...",
          suffixIcon: const Icon(Icons.search),
        ),
      );
}
