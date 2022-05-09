import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HeaderContent extends StatelessWidget {
  final Word _word;
  final audioPlayer = AudioPlayer(playerId: kAudioPlayerId);

  HeaderContent(this._word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _word.word,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Row(
            children: [
              Text(
                _word.ipa,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white70),
              ),
              if (_word.audioUrl != null)
                IconButton(
                  icon: const Icon(Icons.volume_up_rounded),
                  color: Colors.white70,
                  onPressed: () => audioPlayer.play(_word.audioUrl!),
                ),
              const Spacer(),
              AnimatedSmoothIndicator(
                activeIndex: context.watch<ValueNotifier<int>>().value,
                count: _word.defintions.length,
                effect: const WormEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.white70,
                  dotWidth: 10,
                  dotHeight: 10,
                ),
              ),
            ],
          )
        ],
      );
}
