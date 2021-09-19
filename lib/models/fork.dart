import 'package:hive/hive.dart';

part 'fork.g.dart';

@HiveType(typeId: 2)
class Fork {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String ticker;

  @HiveField(2)
  final String unit;

  @HiveField(3)
  final int precision;

  Fork({
    required this.name,
    required this.ticker,
    required this.unit,
    required this.precision,
  });
}
