import 'transaction_response.dart';

class TransactionGroupResponse {
  String type;
  List<TransactionsResponse> transactions;
  int timestamp;
  int block;
  int amount;
  int fee;

  TransactionGroupResponse(
      {required this.type,
      required this.transactions,
      required this.timestamp,
      required this.block,
      required this.amount,
      required this.fee});

  TransactionGroupResponse.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        transactions = (json['transactions'] as List)
            .map((value) => TransactionsResponse.fromJson(value))
            .toList(),
        timestamp = json['timestamp'],
        block = json['block'],
        amount = json['amount'],
        fee = json['fee'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'transactions': transactions.map((value) => value.toJson()).toList(),
        'timestamp': timestamp,
        'block': block,
        'amount': amount,
        'fee': fee
      };
}
