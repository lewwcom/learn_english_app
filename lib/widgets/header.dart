import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

class Header extends StatelessWidget {
  static const expandedHeight = kToolbarHeight * 4.5;

  final Widget _child;

  const Header(this._child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverAppBar(
        // automaticallyImplyLeading: false, => disable back button
        pinned: true,
        floating: true,
        expandedHeight: expandedHeight,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight * 3),
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(kPadding),
            child: _child,
          ),
        ),
      );
}
