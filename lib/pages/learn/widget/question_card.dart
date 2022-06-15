import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/questions_model.dart';
import 'package:learn_english_app/pages/learn/widget/quiz_option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard(
      {Key? key,
      required this.question,
      required this.updateSelected,
      required this.isSelectedAnswer,
      required this.setCorrectAnswer})
      : super(key: key);

  final Question question;
  final Function() updateSelected;
  final bool isSelectedAnswer;
  final Function() setCorrectAnswer;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
      padding: const EdgeInsets.all(kPadding),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Text(
            question.question,
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(color: kBlackColor),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: question.options.length,
            itemBuilder: (BuildContext context, int index) {
              return Option(
                index: index,
                text: question.options[index],
                answer: question.answer,
                updateSelected: updateSelected,
                isSelectedAnswer: isSelectedAnswer,
                setCorrectAnswer: setCorrectAnswer,
              );
            },
          ))
        ],
      ),
    );
  }
}
