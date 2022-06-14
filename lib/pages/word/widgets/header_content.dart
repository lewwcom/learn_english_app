import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/models/word.dart';
import 'package:learn_english_app/services/api_word.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HeaderContent extends StatelessWidget {
  final Word _word;
  final audioPlayer = AudioPlayer(playerId: kAudioPlayerId);

  HeaderContent(this._word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ValueNotifier<String?>(null)), // Vietnamese
          ChangeNotifierProvider(
              create: (context) => ValueNotifier(false)), // Loading state
        ],
        builder: (context, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  _word.word,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                _TranslateButton(_word),
              ],
            ),
            if (context.watch<ValueNotifier<String?>>().value != null)
              Text(
                context.read<ValueNotifier<String?>>().value!,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
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
                  count: _word.definitions.length,
                  effect: const ScrollingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white70,
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotScale: 1.05,
                  ),
                ),
              ],
            )
          ],
        ),
      );
}

class _TranslateButton extends StatelessWidget {
  final Word _word;

  const _TranslateButton(this._word, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> loadingNotifier = context.watch<ValueNotifier<bool>>();
    ValueNotifier<String?> viMeaningNotifier =
        context.read<ValueNotifier<String?>>();
    return loadingNotifier.value
        ? const IconButton(
            icon: SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(color: Colors.white70),
            ),
            onPressed: null,
          )
        : IconButton(
            icon: const Icon(
              Icons.translate,
              color: Colors.white70,
            ),
            onPressed: () async {
              loadingNotifier.value = true;
              try {
                viMeaningNotifier.value = (await read(_word.id!)).viMeaning;
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    e is ApiException ? "Error: $e" : "Unknown error",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ));
              }
              loadingNotifier.value = false;
            },
          );
  }
}
