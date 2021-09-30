
import 'package:arbor/api/responses/transaction_response.dart';

class TransactionModelResponse {
  TransactionModelResponse({
    required this.type,
    required this.timestamp,
    required this.block,
    required this.amount,
    required this.fee,
    required this.transactions
  });

  final String type;
  final int timestamp;
  final int block;
  final int amount;
  final int fee;
  final List<TransactionResponse> transactions;

  factory TransactionModelResponse.fromJson(Map<String, dynamic> json) => TransactionModelResponse(
    type: json["type"],
    timestamp: json["timestamp"],
    block: json["block"],
    amount: json["amount"],
    fee: json["fee"],
    transactions: json["transactions"]
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "timestamp": timestamp,
    "block": block,
    "amount": amount,
    "fee":fee,
    "transactions":transactions
  };
}