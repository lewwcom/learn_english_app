import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/constants.dart';
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
            return _ErrorPage(error);
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

class _ErrorPage extends StatelessWidget {
  final Object _error;

  const _ErrorPage(this._error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Oops!",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: kPadding / 2),
              Text(
                "We cannot load the page :(\n${_error is ApiException ? "Error: $_error" : "Unknown error"}",
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: kPadding),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text("Back to last page"),
              )
            ],
          ),
        ),
      );
}

class LoadingNotifier<T> extends ChangeNotifier {
  T? _result;
  Object? _error;

  LoadingNotifier(Future<T> Function() fetchResult) {
    _fetch(fetchResult);
  }

  Future<void> _fetch(Future<T> Function() fetchResult) async {
    try {
      _result = await fetchResult();
    } catch (e) {
      _error = e;
    }
    notifyListeners();
  }

  T? get result {
    if (_error != null) {
      throw _error!;
    }
    return _result;
  }
}
