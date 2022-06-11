import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/widgets/header/search_notifier.dart';
import 'package:provider/provider.dart';

class HeaderLearn<T> extends StatelessWidget {
  final String _title;
  final String? _searchPageLocation;
  final bool _searchBoxAutoFocus;

  /// Pass [buttonText] and [onButtonPressed] to display button. If
  /// [searchPageLocation] is not null, when user taps on search box, app will be
  /// navigated to your search page.
  const HeaderLearn({
    Key? key,
    required String title,
    String? searchPageLocation,
    bool searchBoxAutoFocus = false,
  })  : _title = title,
        _searchPageLocation = searchPageLocation,
        _searchBoxAutoFocus = searchBoxAutoFocus,
        super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _title,
            style: Theme.of(context)
                .primaryTextTheme
                .headlineLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kPadding),
          _SearchBox<T>(_searchPageLocation, _searchBoxAutoFocus)
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
