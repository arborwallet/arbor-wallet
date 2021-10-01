
import 'package:arbor/models/transaction.dart';
import 'package:hive/hive.dart';

part 'transactions_group.g.dart';

@HiveType(typeId: 3)
class TransactionsGroup {

  @HiveField(0)
  final List<Transaction> transactionsList;

  @HiveField(1)
  final String address;


  TransactionsGroup({
    required this.address,
    required this.transactionsList,
  });
}
