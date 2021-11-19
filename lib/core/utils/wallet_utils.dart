import 'dart:typed_data';

import 'package:arbor/api/responses/record_response.dart';
import 'package:arbor/clvm/program.dart';

final walletPuzzle = Program.parse(
    '(a (q 4 (c 4 (c 5 (c (a 6 (c 2 (c 11 ()))) ()))) 11) (c (q 50 2 (i (l 5) (q 11 (q . 2) (a 6 (c 2 (c 9 ()))) (a 6 (c 2 (c 13 ())))) (q 11 (q . 1) 5)) 1) 1))');

List<RecordResponse> aggregateRecords(
    List<RecordResponse> records, int totalAmount) {
  List<RecordResponse> spendRecords = [];
  var spendAmount = 0;
  calculator:
  while (records.isNotEmpty && spendAmount < totalAmount) {
    for (var i = 0; i < records.length; i++) {
      if (spendAmount + records[i].coin.amount <= totalAmount) {
        var record = records.removeAt(i--);
        spendRecords.add(record);
        spendAmount += record.coin.amount;
        continue calculator;
      }
    }
    var record = records.removeAt(0);
    spendRecords.add(record);
    spendAmount += record.coin.amount;
  }
  if (spendAmount < totalAmount) {
    throw StateError('Insufficient funds.');
  }
  return spendRecords;
}

Uint8List getCoinId(RecordResponse record) {
  return Program.list([
    Program.int(11),
    Program.cons(
        Program.int(1), Program.hex(record.coin.parentCoinInfo.substring(2))),
    Program.cons(
        Program.int(1), Program.hex(record.coin.puzzleHash.substring(2))),
    Program.cons(Program.int(1), Program.int(record.coin.amount))
  ]).run(Program.nil()).program.atom;
}
