import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

class Header extends StatelessWidget {
  static const _expandedHeight = kToolbarHeight * 5;

  final Widget _child;
  final double _bottomHeight;

  const Header(
    this._child, {
    Key? key,
    double bottomHeight = kToolbarHeight * 3,
  })  : _bottomHeight = bottomHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) => SliverAppBar(
        pinned: true,
        floating: true,
        expandedHeight: _expandedHeight,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_bottomHeight),
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(kPadding),
            child: _child,
          ),
        ),
      );
}
