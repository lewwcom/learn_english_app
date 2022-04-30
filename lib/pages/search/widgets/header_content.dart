import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/pages/search/widgets/search_results.dart';
import 'package:provider/provider.dart';

class HeaderContent extends StatelessWidget {
  final String _title;

  const HeaderContent(this._title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: kPadding),
          const _SearchBox()
        ],
      );
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => TextField(
        onChanged: (value) => context.read<SearchNotifier>().query = value,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintText: "Search...",
            suffixIcon: const Icon(Icons.search)),
      );
}
