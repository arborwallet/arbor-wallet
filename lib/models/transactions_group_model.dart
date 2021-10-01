
import 'package:arbor/models/transaction.dart';
import 'package:hive/hive.dart';

part 'transactions_group_model.g.dart';

@HiveType(typeId: 3)
class TransactionsGroupModel {

  @HiveField(0)
  final List<Transaction> transactionsList;

  @HiveField(1)
  final String address;


  TransactionsGroupModel({
    required this.address,
    required this.transactionsList,
  });
}
