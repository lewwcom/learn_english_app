import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';

class Option extends StatefulWidget {
  const Option(
      {Key? key,
      required this.text,
      required this.index,
      required this.answer,
      required this.updateSelected,
      required this.isSelectedAnswer,
      required this.setCorrectAnswer})
      : super(key: key);

  final String text;
  final int index;
  final int answer;
  final Function() updateSelected;
  final bool isSelectedAnswer;
  final Function() setCorrectAnswer;

  @override
  State<StatefulWidget> createState() => _Option();
}

class _Option extends State<Option> {
  bool isCorrect = false;
  bool isSelected = false;

  Color getRightColor() {
    if (isSelected && isCorrect) {
      return kGreenColor;
    }
    if (isSelected && isCorrect == false) {
      return kRedColor;
    }
    return kGrayColor;
  }

  IconData getRightIcon() {
    return getRightColor() == kRedColor ? Icons.close : Icons.done;
  }

  void onSelectAnswer() {
    if (widget.isSelectedAnswer == true) {
      return;
    } else {
      if (widget.index == widget.answer) {
        setState(() {
          isCorrect = true;
        });
        widget.setCorrectAnswer();
      }
      widget.updateSelected();
      setState(() {
        isSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectAnswer,
      child: Container(
        margin: const EdgeInsets.only(top: kPadding),
        padding: const EdgeInsets.all(kPadding - 10),
        decoration: BoxDecoration(
          border: Border.all(color: getRightColor()),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.index + 1}. ${widget.text}",
              style: TextStyle(color: getRightColor(), fontSize: 16),
            ),
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                  color: getRightColor() == kGrayColor
                      ? Colors.transparent
                      : getRightColor(),
                  border: Border.all(color: getRightColor()),
                  borderRadius: BorderRadius.circular(50)),
              child: isSelected == false
                  ? null
                  : Icon(
                      getRightIcon(),
                      size: 16,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
