import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/pages/loading/error_page.dart';

class FinishLearnPage extends StatelessWidget {
  final int checkPage;

  const FinishLearnPage(this.checkPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => checkPage == 0
      ? ErrorPage(
          displayText: "Congratulation!",
          contentText: "You have learned all the words today",
          buttonText: "Back to learning page",
          onPressed: () => context.push("/learn"))
      : ErrorPage(
          displayText: "Congratulation!",
          contentText: "You have learned all the words today",
          buttonText: "Back",
          onPressed: () => context.pop());
}
