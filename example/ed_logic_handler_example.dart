import 'package:ed_logic_handler/src/ed_logic_handler_base.dart';

void main() {
  Future<int> calculateMath1() async {
    return 2 + 2;
  }

  Future<double> calculateMath2() async {
    return 10.0/2;
  }

  final exampleLogic1 = ExampleLogic1<int>(logic: calculateMath1);
  final exampleLogic2 = ExampleLogic2<double>(logic: calculateMath2, timeout: 2);

  exampleLogic1.next = exampleLogic2;
  exampleLogic1.handle(finishCallback: () {
    print("Chain Finish");
    print("Data1: ${exampleLogic1.data}");
    print("Error1: ${exampleLogic1.error}");
    print("Data2: ${exampleLogic2.data}");
    print("Error2: ${exampleLogic2.error}");
  });
}

class ExampleLogic1<T> extends BaseLogicHandler<T> {
  ExampleLogic1({required AsyncCallback<T> logic, int? timeout}) : super(execute: logic, timeout: timeout);

  T? data;
  EdLogicHandlerError? error;
  @override
  void returnData<U>(U data) {
    print("data: $data, type: ${data.runtimeType}");
    if (data is T) {
      this.data = data;
    } else if (data is EdLogicHandlerError) {
      print("Error: ${data.message}, ${data.error}, ${data.stackTrace}");
      error = data;
    }
  }
}

class ExampleLogic2<T> extends BaseLogicHandler<T> {
  ExampleLogic2({required AsyncCallback<T> logic, int? timeout}) : super(execute: logic, timeout: timeout);
  T? data;
  EdLogicHandlerError? error;
  @override
  void returnData<U>(U data) {
    print("data: $data, type: ${data.runtimeType}");
    if (data is T) {
      this.data = data;
    } else if (data is EdLogicHandlerError) {
      print("Error: ${data.message}, ${data.error}, ${data.stackTrace}");
      error = data;
    }
  }
}
