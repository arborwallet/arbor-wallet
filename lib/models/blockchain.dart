import 'package:hive/hive.dart';

part 'blockchain.g.dart';

@HiveType(typeId: 2)
class Blockchain {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String ticker;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final int precision;

  @HiveField(4)
  final String logo;

  @HiveField(5)
  final int network_fee;

  @HiveField(6)
  final String extra_data;

  Blockchain({
    required this.name,
    required this.ticker,
    required this.unit,
    required this.precision,
    required this.logo,
    required this.network_fee,
    required this.extra_data
  });
}
