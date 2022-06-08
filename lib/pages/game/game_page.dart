import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: kPrimaryColor2,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: height / 6,
                padding: const EdgeInsets.all(kPadding * 1.5),
                child: Text("abc"),
              ),
              Expanded(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        5,
                        (index) => GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(right: 5),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: const Color(0xFF818384))),
                                height: 100,
                                width: 100,
                                child: const Text('A',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24)),
                              ),
                              onTap: () {},
                            ))),
              ),
              Container(
                height: height / 3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: List.generate(
                      2,
                      (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  5,
                                  (j) => GestureDetector(
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFF818384))),
                                          height: 30,
                                          width: 30,
                                          child: const Text('A',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24)),
                                        ),
                                        onTap: () {},
                                      )))),
                    )),
              )
            ]));
  }
}
