import 'transaction_group_response.dart';

class TransactionListResponse {
  List<TransactionGroupResponse>? transactions;

  TransactionListResponse({this.transactions});

  TransactionListResponse.fromJson(Map<String, dynamic> json) {
    if (json['transaction_groups'] != null) {
      transactions = [];
      json['transaction_groups'].forEach((v) {
        transactions!.add(new TransactionGroupResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transactions != null) {
      data['transaction_groups'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




