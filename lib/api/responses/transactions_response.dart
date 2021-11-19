import 'transaction_group_response.dart';

class TransactionListResponse {
  List<TransactionGroupResponse> transactions;

  TransactionListResponse({required this.transactions});

  TransactionListResponse.fromJson(Map<String, dynamic> json)
      : transactions = (json['transaction_groups'] as List)
            .map((value) => TransactionGroupResponse.fromJson(value))
            .toList();

  Map<String, dynamic> toJson() =>
      {'transaction_groups': transactions.map((value) => value.toJson())};
}
