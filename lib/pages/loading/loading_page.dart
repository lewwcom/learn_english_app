import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:learn_english_app/api/api_exception.dart';
import 'package:learn_english_app/pages/loading/error_page.dart';
import 'package:learn_english_app/router.dart';
import 'package:learn_english_app/utilities/loading_notifier.dart';
import 'package:provider/provider.dart';

class LoadingPage<T> extends StatefulWidget {
  final T? _initialValue;
  final Future<T> Function()? _fetchResult;
  final LoadingNotifier<T>? _loadingNotifier;
  final bool _willDisposeNotifier;
  final Equality? _equality;
  final String _notifyAboutChangeText;
  final Widget Function(BuildContext context, T data) _builder;
  final bool _refreshOnPopNext;

  /// LoadingPage will call [builder] immediately if [initialValue] is not null.
  /// If [refreshOnPopNext] is true then [loadingNotifier] or [fetchResult] must
  /// be not null. If [loadingNotifier] is not null, [initialValue] and
  /// [fetchResult] will be ignored. Or else, [initialValue] and [fetchResult]
  /// must not be both null. In this case, if [fetchResult] is not null,
  /// a `LoadingNotifier<T>` will be created.
  ///
  /// `LoadingNotifier<T>` can be accessed by successors using:
  /// ```dart
  /// context.read<LoadingNotifier<T>>()
  /// ```
  ///
  /// Since this widget will be updated when
  /// `LoadingNotifier<T>::notifyListeners` is called, successors should not
  /// be listen to changes on `LoadingNotifier<T>`.
  ///
  /// If [willDisposeNotifier] is true, provided [loadingNotifier] will be
  /// disposed when `State<LoadingPage<T>>` is disposed. `LoadingNotifier<T>`
  /// created from [fetchResult] will always be disposed.
  ///
  /// If [equality] is provided, when data is changed, a [SnackBar] with
  /// [notifyAboutChangeText] message will be displayed if
  /// `equality.equals(oldData, newData) == false`. This behavior can be affect
  /// by [loadingNotifier] if it implement [ShouldNotifyAboutUpdateHelper].
  const LoadingPage({
    Key? key,
    T? initialValue,
    Future<T> Function()? fetchResult,
    LoadingNotifier<T>? loadingNotifier,
    bool willDisposeNotifier = false,
    Equality? equality,
    String notifyAboutChangeText = "Updated!",
    required Widget Function(BuildContext context, T data) builder,
    bool refreshOnPopNext = false,
  })  : assert(loadingNotifier != null ||
            fetchResult != null ||
            initialValue != null),
        assert(!(refreshOnPopNext &&
            (fetchResult == null && loadingNotifier == null))),
        _initialValue = initialValue,
        _fetchResult = fetchResult,
        _loadingNotifier = loadingNotifier,
        _equality = equality,
        _notifyAboutChangeText = notifyAboutChangeText,
        _willDisposeNotifier = willDisposeNotifier,
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
  bool _shouldNotifyAboutUpdate = false;

  @override
  void initState() {
    super.initState();
    if (widget._loadingNotifier != null) {
      _loadingNotifier = widget._loadingNotifier;
      _result = _loadingNotifier!.result;
    } else if (widget._fetchResult != null) {
      _result = widget._initialValue;
      _loadingNotifier = LoadingNotifier<T>(
        widget._fetchResult!,
        fetchOnCreate: _result == null,
      );
    }
    _loadingNotifier?.addListener(_update);
  }

  void _update() {
    try {
      T? oldResult = _result;
      T? newResult = _loadingNotifier!.result;

      bool shouldNotifyAboutUpdate =
          (_loadingNotifier is! ShouldNotifyAboutUpdateHelper ||
                  (_loadingNotifier as ShouldNotifyAboutUpdateHelper)
                      .shouldNotifyAboutUpdate) &&
              widget._equality != null &&
              oldResult != null &&
              newResult != null &&
              !widget._equality!.equals(oldResult, newResult);

      setState(() {
        _result = newResult;
        _shouldNotifyAboutUpdate = shouldNotifyAboutUpdate;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e);
    }
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
    if (widget._loadingNotifier == null || widget._willDisposeNotifier) {
      _loadingNotifier?.dispose();
    } else {
      _loadingNotifier?.removeListener(_update);
    }
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _update();
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
    if (_shouldNotifyAboutUpdate) {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) =>
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              widget._notifyAboutChangeText,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          )));
      _shouldNotifyAboutUpdate = false;
    }
    return _result != null
        ? ChangeNotifierProvider.value(
            value: _loadingNotifier,
            builder: (context, child) => widget._builder(context, _result!))
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

class ShouldNotifyAboutUpdateHelper {
  bool shouldNotifyAboutUpdate = false;
}
