import 'dart:async';

import 'package:async/async.dart';

typedef AsyncCallback<T> = Future<T> Function();

class EdLogicHandlerError extends Error {
  EdLogicHandlerError(this.message, this.stackTrace, this.error);
  final String message;
  @override
  final StackTrace? stackTrace;
  final Object? error;
  @override
  String toString() {
    return message;
  }
}

abstract class BaseLogicHandler<T> {
  BaseLogicHandler({required Future<T> Function()? execute, this.timeout}) {
    e = CancelableOperation.fromFuture(execute!());
  }
  CancelableOperation<T>? e;
  BaseLogicHandler? _next;
  set next(BaseLogicHandler? next) => _next = next;
  int? timeout;

  Timer? _timer;

  Future<void> handle({required Function() finishCallback}) async {
    print(timeout);
    _timer ??= Timer(Duration(seconds: timeout ?? 10), () async {
      print("Timeout");
      await e?.cancel();
      returnData<EdLogicHandlerError>(EdLogicHandlerError("Timeout", StackTrace.current, null));
      finishCallback();
    });
    if (e != null) {
      e!.then((res) async {
        returnData<T>(res);
        if (_next != null) {
          _timer!.cancel();
          _timer = null;
          await _next!.handle(finishCallback: finishCallback);
        } else {
          _timer!.cancel();
          _timer = null;
          finishCallback();
        }
      }, onError: (error, stackTrace) {
        _timer!.cancel();
        _timer = null;
        returnData<EdLogicHandlerError>(EdLogicHandlerError(error.toString(), stackTrace, error));
        finishCallback();
      });
    } else {
      _timer!.cancel();
      _timer = null;
      finishCallback();
    }
  }

  void returnData<U>(U data);
}
