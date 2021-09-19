class BaseResponse {
  BaseResponse({
    required this.success,
    this.error,
  });

  final bool success;
  final String? error;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    success: json["success"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
  };
}