
import 'package:hive/hive.dart';

import 'models.dart';

part 'transactions_list.g.dart';

@HiveType(typeId: 3)
class TransactionsList {

  @HiveField(0)
  final List<TransactionGroup> list;


  TransactionsList({
    required this.list,
  });
}
