// Local class for
class Operation<T> {
  Operation(this.isSuccess,
      {this.userMsg, this.result, this.debugMsg = 'Operation log: '});

  final bool isSuccess;
  final String debugMsg;
  final String? userMsg;
  final T? result;

  @override
  String toString() {
    return '[Operation ${isSuccess ? 'failed' : 'succeeded'} of type ${T.runtimeType}: $debugMsg]';
  }
}
