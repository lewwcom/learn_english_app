import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/pages/search/widgets/header_content.dart';
import 'package:learn_english_app/pages/search/widgets/search_history.dart';
import 'package:learn_english_app/pages/search/widgets/search_results.dart';
import 'package:learn_english_app/pages/search/widgets/words_of_the_day.dart';
import 'package:learn_english_app/widgets/header.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const String _title = "Lookup";

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SearchNotifier("")),
          ChangeNotifierProvider(
            create: (context) => SearchHistoryNotifier(<String>[]),
          )
        ],
        builder: (context, child) => Scaffold(
          body: CustomScrollView(
            slivers: [
              const Header(HeaderContent(_title)),
              context.select((SearchNotifier s) => s.query).isEmpty
                  ? const SliverPadding(
                      padding: EdgeInsets.all(kPadding),
                      sliver: SearchHistory(),
                    )
                  : const SliverPadding(
                      padding: EdgeInsets.all(kPadding),
                      sliver: SearchResults(),
                    ),
              WordsOfTheDay()
            ],
          ),
        ),
      );
}
