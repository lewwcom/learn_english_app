import 'package:flutter/material.dart';
import 'package:learn_english_app/constants.dart';
import 'package:provider/provider.dart';

enum _LoadingState { none, loading, done, failed }

class LoadingButton<T> extends StatelessWidget {
  final String _buttonText;
  final Future<T> Function()? _onPressed;
  final Future<void> Function(T? result)? _onDone;
  final TextStyle? _textStyle;
  final Color? _buttonColor;

  const LoadingButton(
    this._buttonText, {
    Key? key,
    Future<T> Function()? onPressed,
    Future<void> Function(T? result)? onDone,
    TextStyle? textStyle,
    Color? buttonColor,
  })  : _onPressed = onPressed,
        _onDone = onDone,
        _textStyle = textStyle,
        _buttonColor = buttonColor,
        super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ValueNotifier(_LoadingState.none),
        builder: (context, child) {
          ValueNotifier<_LoadingState> stateNotifier =
              context.watch<ValueNotifier<_LoadingState>>();
          switch (stateNotifier.value) {
            case _LoadingState.none:
              return ElevatedButton(
                onPressed: _onPressed != null
                    ? () async {
                        try {
                          stateNotifier.value = _LoadingState.loading;
                          T _result = await _onPressed!();
                          stateNotifier.value = _LoadingState.done;
                          if (_onDone != null) {
                            await Future.delayed(
                              const Duration(seconds: 1),
                              () async => await _onDone!(_result),
                            );
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                          stateNotifier.value = _LoadingState.failed;
                        }
                      }
                    : null,
                child: Text(_buttonText, style: _textStyle),
                style: ElevatedButton.styleFrom(primary: _buttonColor),
              );
            case _LoadingState.loading:
              return ElevatedButton(
                onPressed: null,
                child: Row(
                  children: [
                    const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: kPadding / 2),
                    Text(_buttonText, style: _textStyle)
                  ],
                ),
              );
            default:
              bool isDone = stateNotifier.value == _LoadingState.done;
              return ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(isDone ? Icons.done : Icons.error,
                    size: kSmallIconSize),
                label: Text(isDone ? "Done" : "Failed", style: _textStyle),
                style: ElevatedButton.styleFrom(
                    primary: isDone
                        ? Colors.green
                        : Theme.of(context).colorScheme.error),
              );
          }
        },
      );
}
