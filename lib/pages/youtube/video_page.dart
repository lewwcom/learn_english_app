import 'package:flutter/material.dart';
import 'package:learn_english_app/models/subtitle_model.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/pages/word/word_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/gestures.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  VideoScreen(this.id);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;
  String subString = """1
00:00:03,400 --> 00:00:06,177
In this lesson, we're going to be talking about finance. And

2
00:00:06,177 --> 00:00:10,009
one of the most important aspects of finance is interest.

3
00:00:10,009 --> 00:00:13,655
When I go to a bank or some other lending institution

4
00:00:13,655 --> 00:00:17,720
to borrow money, the bank is happy to give me that money. But then I'm

5
00:00:17,900 --> 00:00:21,480
going to be paying the bank for the privilege of using their money. And that

6
00:00:21,660 --> 00:00:26,440
amount of money that I pay the bank is called interest. Likewise, if I put money

7
00:00:26,620 --> 00:00:31,220
in a savings account or I purchase a certificate of deposit, the bank just

8
00:00:31,300 --> 00:00:35,800
doesn't put my money in a little box and leave it there until later. They take

9
00:00:35,800 --> 00:00:40,822
my money and lend it to someone else. So they are using my money.

10
00:00:40,822 --> 00:00:44,400
The bank has to pay me for the privilege of using my money.

11
00:00:44,400 --> 00:00:48,700
Now what makes banks profitable is the rate

12
00:00:48,700 --> 00:00:53,330
that they charge people to use the bank's money is higher than the rate that they

13
00:00:53,510 --> 00:01:00,720
pay people like me to use my money. The amount of interest that a person pays or

14
00:01:00,800 --> 00:01:06,640
earns is dependent on three things. It's dependent on how much money is involved.

15
00:01:06,820 --> 00:01:11,300
It's dependent upon the rate of interest being paid or the rate of interest being

16
00:01:11,480 --> 00:01:17,898
charged. And it's also dependent upon how much time is involved. If I have

17
00:01:17,898 --> 00:01:22,730
a loan and I want to decrease the amount of interest that I'm going to pay, then

18
00:01:22,800 --> 00:01:28,040
I'm either going to have to decrease how much money I borrow, I'm going to have

19
00:01:28,220 --> 00:01:32,420
to borrow the money over a shorter period of time, or I'm going to have to find a

20
00:01:32,600 --> 00:01:37,279
lending institution that charges a lower interest rate. On the other hand, if I

21
00:01:37,279 --> 00:01:41,480
want to earn more interest on my investment, I'm going to have to invest

22
00:01:41,480 --> 00:01:46,860
more money, leave the money in the account for a longer period of time, or

23
00:01:46,860 --> 00:01:49,970
find an institution that will pay me a higher interest rate.""";
  List<Subtitle>? subtitles;
  List<String>? currentSubtitles;
  List<String>? previousSubtitles;
  List<String>? nextSubtitles;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        enableCaption: true,
        captionLanguage: 'en',
      ),
    );
    currentSubtitles = [];
    previousSubtitles = [];
    nextSubtitles = [];
    _initSubList();
  }

  _initSubList() {
    List<String> tmp = subString.split("\n");
    List<Subtitle> tmpSub = [];
    for (var i = 1; i < tmp.length; i = i + 4) {
      List<String> duration = tmp[i].split(" ");
      String sub = tmp[i + 1];
      Subtitle subtitle = Subtitle.fromString(duration[0], duration[2], sub);
      tmpSub.add(subtitle);
    }
    setState(() {
      subtitles = tmpSub;
    });
  }

  _changeSubtitles(Duration pos) {
    List<String> tmpCurrentSub = [];
    List<String> tmpPreviousSub = [];
    List<String> tmpNextSub = [];
    String? currentStr;
    String? previousStr;
    String? nextStr;
    for (Subtitle subtitle in subtitles!) {
      var cmp1 = pos.compareTo(subtitle.start);
      var cmp2 = pos.compareTo(subtitle.end);
      if (cmp1 < 0) {
        previousStr = subtitle.subtitle;
      }
      if (cmp1 >= 0 && cmp2 <= 0) {
        currentStr = subtitle.subtitle;
      }
      if (nextStr == null && cmp2 > 0) {
        nextStr = subtitle.subtitle;
      }
    }
    if (previousStr != null) tmpPreviousSub = previousStr.split(' ');
    if (currentStr != null) tmpCurrentSub = currentStr.split(' ');
    if (nextStr != null) tmpNextSub = nextStr.split(' ');
    setState(() {
      currentSubtitles = tmpCurrentSub;
      previousSubtitles = tmpPreviousSub;
      nextSubtitles = tmpNextSub;
    });
  }

  _buildSubtitles() {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 25.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);
    return Container(
        margin: EdgeInsets.only(left: 10, top: 150, right: 20),
        padding: EdgeInsets.all(10.0),
        child: Center(
            child: RichText(
          text: TextSpan(
              style: defaultStyle,
              children: currentSubtitles!.map((subtitle) {
                return TextSpan(
                    text: subtitle + " ",
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print('${subtitle}');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WordPage(Word.fromString(subtitle)),
                            ));
                      });
              }).toList()),
        )));
  }

  // _buildPreSubtitles() {
  //   TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 25.0);
  //   TextStyle linkStyle = TextStyle(color: Colors.blue);
  //   return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
  //       padding: EdgeInsets.all(10.0),
  //       child: Center(
  //           child: RichText(
  //         text: TextSpan(
  //             style: defaultStyle,
  //             children: previousSubtitles.map((subtitle) {
  //               return TextSpan(
  //                 text: subtitle + " ",
  //               );
  //             }).toList()),
  //       )));
  // }

  // _buildNextSubtitles() {
  //   TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 20.0);
  //   TextStyle linkStyle = TextStyle(color: Colors.blue);
  //   return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
  //       padding: EdgeInsets.all(10.0),
  //       child: Center(
  //           child: RichText(
  //         text: TextSpan(
  //             style: defaultStyle,
  //             children: nextSubtitles.map((subtitle) {
  //               return TextSpan(
  //                 text: subtitle + " ",
  //               );
  //             }).toList()),
  //       )));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    print('Player is ready.');
                    _controller.addListener(() {
                      print(_controller.value.position);
                      _changeSubtitles(_controller.value.position);
                    });
                  });
            } else {
              return _buildSubtitles();
            }
          },
        ));
  }
}
