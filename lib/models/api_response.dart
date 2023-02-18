class ApiResponse<T> {
  ApiResponse(this.httpStatus, this.message, this.content, this.isSuccess);

  final int httpStatus;
  final String? message;
  final T? content;
  final bool isSuccess;
}
