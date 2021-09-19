

import 'base_response.dart';
import 'fork_response.dart';
import 'transaction_response.dart';

class TransactionsResponse extends BaseResponse {
  TransactionsResponse({
    required this.success,
    this.error,
    required this.transactions,
    required this.balance,
    required this.fork,
  }) : super(success: success, error: error);

  final bool success;
  final String? error;
  final List<TransactionResponse> transactions;
  final int balance;
  final ForkResponse fork;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) => TransactionsResponse(
    success: json["success"],
    error: json["error"] == null ? null : json["error"],
    transactions: List<TransactionResponse>.from(json["transactions"].map((x) => TransactionResponse.fromJson(x))),
    balance: json["balance"],
    fork: ForkResponse.fromJson(json["fork"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error == null ? null : error,
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
    "balance": balance,
    "fork": fork.toJson(),
  };
}