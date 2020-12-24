class FailureNetwork {
  // Use something like "int code;" if you want to translate error messages
  final String message;

  FailureNetwork(this.message);

  @override
  String toString() => message;
}
