import 'package:arbor/api/responses.dart';

class KeygenResponse extends BaseResponse {
  KeygenResponse({
    required this.success,
    this.error,
    required this.phrase,
    required this.privateKey,
    required this.publicKey,
  }) : super(success: success, error: error);

  final bool success;
  final String? error;
  final String phrase;
  final String privateKey;
  final String publicKey;

  factory KeygenResponse.fromJson(Map<String, dynamic> json) {
    return KeygenResponse(
      success: json['success'],
      error: json["error"] == null ? null : json["error"],
      phrase: json['phrase'],
      privateKey: json['private_key'],
      publicKey: json['public_key'],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error == null ? null : error,
    "phrase": phrase,
    "privateKey": privateKey,
    "publicKey": publicKey,
  };
}