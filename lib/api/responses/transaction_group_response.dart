import 'transaction_response.dart';

class TransactionGroupResponse {
  String? type;
  List<TransactionsResponse>? transactions;
  int? timestamp;
  int? block;
  int? amount;
  int? fee;

  TransactionGroupResponse(
      {this.type,
        this.transactions,
        this.timestamp,
        this.block,
        this.amount,
        this.fee});

  TransactionGroupResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['transactions'] != null) {
      transactions =[];
      json['transactions'].forEach((v) {
        transactions!.add(new TransactionsResponse.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
    block = json['block'];
    amount = json['amount'];
    fee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    data['block'] = this.block;
    data['amount'] = this.amount;
    data['fee'] = this.fee;
    return data;
  }
}