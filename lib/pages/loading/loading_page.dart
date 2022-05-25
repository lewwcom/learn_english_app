import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/pages/loading/error_page.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:provider/provider.dart';

class LoadingPage<T> extends StatelessWidget {
  final Future<T> Function() _fetchResult;
  final Widget Function(T data) _builder;

  const LoadingPage({
    Key? key,
    required Future<T> Function() fetchResult,
    required Widget Function(T data) builder,
  })  : _fetchResult = fetchResult,
        _builder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LoadingNotifier<T>(_fetchResult),
        builder: (context, child) {
          try {
            final T? result = context.watch<LoadingNotifier<T>>().result;
            return result != null ? _builder(result) : child!;
          } catch (error) {
            return ErrorPage(
              displayText: "Oops",
              contentText:
                  "We cannot load the page :(\n${error is ApiException ? "Error: $error" : "Unknown error"}",
            );
          }
        },
        child: Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) => Center(
              child: SizedBox(
                width: constraints.maxWidth / 2,
                child: const LinearProgressIndicator(),
              ),
            ),
          ),
        ),
      );
}
