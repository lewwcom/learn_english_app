import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/models/subtitle_model.dart';
import 'package:learn_english_app/models/subtitle_response.dart';
import 'package:learn_english_app/services/api_subtitle.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/gestures.dart';

class VideoScreen extends StatefulWidget {
  final String id;

  // ignore: use_key_in_widget_constructors
  const VideoScreen(this.id);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  late String subString;
  List<Subtitle>? subtitles;
  List<String>? currentSubtitles;
  List<String>? previousSubtitles;
  List<String>? nextSubtitles;
  int count = 0;

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

  _initSubList() async {
    SubtitleResponse subRes = await readSubtitle(widget.id);
    if (subRes.success == true) {
      subString = subRes.content;
    } else {
      subString = '';
    }
    print(subString);
    List<String> tmp = subString.split("\n");
    List<Subtitle> tmpSub = [];
    for (var i = 1; i < tmp.length; i = i + 4) {
      List<String> duration = tmp[i].split(" ");
      String sub = tmp[i + 1];
      if (sub.length == 1) continue;
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
    for (var i = 0; i < subtitles!.length; ++i) {
      Subtitle subtitle = subtitles![i];
      var cmp1 = pos.compareTo(subtitle.start);
      var cmp2 = pos.compareTo(subtitle.end);
      if (cmp1 >= 0 && cmp2 <= 0) {
        currentStr = subtitle.subtitle;
        if (i > 0) {
          previousStr = subtitles![i - 1].subtitle;
        }
        if (i < subtitles!.length - 1) {
          nextStr = subtitles![i + 1].subtitle;
        }
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
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 18.0);
    TextStyle linkStyle = const TextStyle(color: Colors.blue);
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
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
                        _controller.pause();
                        context.push("/words/${subtitle}");
                      });
              }).toList()),
        )));
  }

  _buildPreSubtitles() {
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 15.0);
    return Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 10),
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: RichText(
          text: TextSpan(
              style: defaultStyle,
              children: previousSubtitles!.map((subtitle) {
                return TextSpan(
                  text: subtitle + " ",
                );
              }).toList()),
        )));
  }

  _buildNextSubtitles() {
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 15.0);
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        child: Center(
            child: RichText(
          text: TextSpan(
              style: defaultStyle,
              children: nextSubtitles!.map((subtitle) {
                return TextSpan(
                  text: subtitle + " ",
                );
              }).toList()),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    print('Player is ready.');
                    _controller.addListener(() {
                      ++count;
                      if (count == 5) {
                        _changeSubtitles(_controller.value.position);
                        count = 0;
                      }
                    });
                  });
            } else if (index == 1) {
              return _buildPreSubtitles();
            } else if (index == 2) {
              return _buildSubtitles();
            } else {
              return _buildNextSubtitles();
            }
          },
        ));
  }
}
