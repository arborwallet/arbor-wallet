

import 'base_response.dart';
import 'fork_response.dart';

class BalanceResponse extends BaseResponse {
  BalanceResponse({
    required this.success,
    this.error,
    required this.balance,
    required this.fork,
  }) : super(success: success, error: error);

  final bool success;
  final String? error;
  final int balance;
  final ForkResponse fork;

  factory BalanceResponse.fromJson(Map<String, dynamic> json) => BalanceResponse(
    success: json["success"],
    error: json["error"] == null ? null : json["error"],
    balance: json["balance"],
    fork: ForkResponse.fromJson(json["fork"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error == null ? null : error,
    "balance": balance,
    "fork": fork.toJson(),
  };
}