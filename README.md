## `BaseLogicHandler<T>` Class

This abstract class defines the underlying structure that executes asynchronous operations.

- **Execution Function**: It accepts an asynchronous function named `execution` and this function is wrapped with `CancelableOperation`. In this way, it can be canceled after a certain timeout period.

- **`returnData<U>` Method**: It defines a `returnData<U>` method for the operation results (`data` or `error`), but this method provides no concrete functionality; It must be implemented by subclasses.

- **`handle` Method**: Manages process initiation, results processing, and timeouts. Also, if there is a next transaction (`_next`), it starts that transaction in a chained manner.

## `EdLogicHandlerError` Error Class

Defines a custom error type and stores the error message, error object and `StackTrace`.

## Usage

```dart
  final exampleLogic1 = ExampleLogic1<int>(execution: calculateMath1);
  final exampleLogic2 = ExampleLogic2<double>(execution: calculateMath2, timeout: 2);

  exampleLogic1.next = exampleLogic2;
  exampleLogic1.handle(finishCallback: () {
    print("Chain Finish");
    print("Data1: ${exampleLogic1.data}");
    print("Error1: ${exampleLogic1.error}");
  });

```