import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/pages/loading/error_page.dart';
import 'package:learn_english_app/router.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';

class LoadingPage<T> extends StatefulWidget {
  final T? _initialValue;
  final Future<T> Function()? _fetchResult;
  final Widget Function(T data) _builder;
  final bool _refreshOnPopNext;

  /// LoadingPage will call [builder] immediately if [initialValue] is not null. If
  /// [refreshOnPopNext] is true then [fetchResult] must not be null. [initialValue]
  /// and [fetchResult] must not be both null.
  const LoadingPage({
    Key? key,
    T? initialValue,
    Future<T> Function()? fetchResult,
    required Widget Function(T data) builder,
    bool refreshOnPopNext = false,
  })  : assert(fetchResult != null || initialValue != null),
        assert(!(refreshOnPopNext && (fetchResult == null))),
        _initialValue = initialValue,
        _fetchResult = fetchResult,
        _builder = builder,
        _refreshOnPopNext = refreshOnPopNext,
        super(key: key);

  @override
  State<LoadingPage<T>> createState() => _LoadingPageState<T>();
}

class _LoadingPageState<T> extends State<LoadingPage<T>> with RouteAware {
  late final LoadingNotifier<T>? _loadingNotifier;
  T? _result;
  Object? _error;

  @override
  void initState() {
    _result = widget._initialValue;
    if (widget._fetchResult != null) {
      _loadingNotifier = LoadingNotifier<T>(
        widget._fetchResult!,
        fetchOnCreate: _result == null,
      );
      _loadingNotifier!.addListener(() => setState(() {
            try {
              _result = _loadingNotifier!.result;
              _error = null;
            } catch (error) {
              _error = error;
            }
          }));
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget._refreshOnPopNext) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    }
  }

  @override
  void dispose() {
    _loadingNotifier?.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      _result = null;
      _error = null;
    });
    _loadingNotifier!.fetch();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorPage(
        displayText: "Oops",
        contentText:
            "We cannot load the page :(\n${_error is ApiException ? "Error: $_error" : "Unknown error"}",
      );
    }
    return _result != null
        ? widget._builder(_result!)
        : Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: SizedBox(
                  width: constraints.maxWidth / 2,
                  child: const LinearProgressIndicator(),
                ),
              ),
            ),
          );
  }
}
