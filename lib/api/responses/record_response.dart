import 'package:arbor/api/responses/coin_response.dart';

class RecordResponse {
  CoinResponse coin;
  int confirmedBlockIndex;
  int spentBlockIndex;
  bool spent;
  bool coinbase;
  int timestamp;

  RecordResponse(
      {required this.coin,
      required this.confirmedBlockIndex,
      required this.spentBlockIndex,
      required this.spent,
      required this.coinbase,
      required this.timestamp});

  RecordResponse.fromJson(Map<String, dynamic> json)
      : coin = CoinResponse.fromJson(json['coin']),
        confirmedBlockIndex = json['confirmed_block_index'],
        spentBlockIndex = json['spent_block_index'],
        spent = json['spent'],
        coinbase = json['coinbase'],
        timestamp = json['timestamp'];

  Map<String, dynamic> toJson() => {
        'coin': coin.toJson(),
        'confirmed_block_index': confirmedBlockIndex,
        'spent_block_index': spentBlockIndex,
        'coinbase': coinbase,
        'timestamp': timestamp
      };
}
