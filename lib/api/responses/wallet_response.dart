import 'package:arbor/api/responses.dart';

import 'fork_response.dart';

class WalletResponse extends BaseResponse {
  WalletResponse({
    required this.success,
    this.error,
    required this.address,
    required this.fork,
  }) : super(success: success, error: error);

  final bool success;
  final String? error;
  final String address;
  final ForkResponse fork;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
    success: json["success"],
    error: json["error"] == null ? null : json["error"],
    address: json["address"],
    fork: ForkResponse.fromJson(json["fork"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error == null ? null : error,
    "address": address,
    "fork": fork.toJson(),
  };
}