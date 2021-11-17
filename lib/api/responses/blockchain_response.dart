class BlockchainResponse {
  BlockchainData blockchainData;

  BlockchainResponse({required this.blockchainData});

  BlockchainResponse.fromJson(Map<String, dynamic> json)
      : blockchainData = BlockchainData.fromJson(json['blockchain']);

  Map<String, dynamic> toJson() => {'blockchain': blockchainData.toJson()};
}

class BlockchainData {
  String name;
  String unit;
  String logo;
  String ticker;
  int precision;
  int blockchainFee;
  String aggSigMeExtraData;

  BlockchainData(
      {required this.name,
      required this.unit,
      required this.logo,
      required this.ticker,
      required this.precision,
      required this.blockchainFee,
      required this.aggSigMeExtraData,});

  BlockchainData.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        unit = json['unit'],
        logo = json['logo'],
        ticker = json['ticker'],
        precision = json['precision'],
        blockchainFee = json['blockchain_fee'],
        aggSigMeExtraData = json['agg_sig_me_extra_data'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'unit': unit,
        'logo': logo,
        'ticker': ticker,
        'precision': precision,
        'blockchain_fee': blockchainFee,
        'agg_sig_me_extra_data':aggSigMeExtraData
      };
}
