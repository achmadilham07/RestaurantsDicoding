import 'dart:io';

String returnMessageException(var errorType) {
  switch (errorType) {
    case SocketException:
      return 'No Internet';
    case HttpException:
      return 'No Service Found';
    case FormatException:
      return 'Invalid Data Format';
    default:
      return errorType.message;
  }
}
