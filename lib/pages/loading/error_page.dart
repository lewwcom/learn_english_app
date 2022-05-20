import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/constants.dart';
import 'package:learn_english_app/router.dart';

class ErrorPage extends StatelessWidget {
  final String _displayText;
  final String _contentText;
  final String? _buttonText;
  final void Function()? _onPressed;
  final CrossAxisAlignment _horizontalAlignment;

  /// [buttonText] and [onPressed] must both be not null in order to enable
  /// action button of the page.
  const ErrorPage({
    Key? key,
    required String displayText,
    required String contentText,
    String? buttonText,
    void Function()? onPressed,
    bool leftAligned = false,
  })  : _displayText = displayText,
        _contentText = contentText,
        _buttonText = buttonText,
        _onPressed = onPressed,
        _horizontalAlignment =
            leftAligned ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    bool haveActionButton = _buttonText != null && _onPressed != null;
    bool canPop = GoRouter.of(context).navigator!.canPop();
    void Function() goBack =
        canPop ? () => context.pop() : () => context.go(initialLocation);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: _horizontalAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _displayText,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: kPadding / 2),
            Text(
              _contentText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kPadding),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                haveActionButton
                    ? OutlinedButton(
                        onPressed: goBack,
                        child:
                            const Icon(Icons.arrow_back, size: kSmallIconSize))
                    : ElevatedButton(
                        child: Text(
                            canPop ? "Back to last page" : "Go to home page"),
                        onPressed: goBack,
                      ),
                if (haveActionButton) ...[
                  const SizedBox(width: kPadding / 2),
                  ElevatedButton(
                    onPressed: _onPressed,
                    child: Text(_buttonText!),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
