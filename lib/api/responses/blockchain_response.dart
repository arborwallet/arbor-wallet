class BlockchainResponse {
  BlockchainData? blockchainData;

  BlockchainResponse({this.blockchainData});

  BlockchainResponse.fromJson(Map<String, dynamic> json) {
    blockchainData = json['blockchain'] != null
        ? new BlockchainData.fromJson(json['blockchain'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.blockchainData != null) {
      data['blockchain'] = this.blockchainData!.toJson();
    }
    return data;
  }
}

class BlockchainData {
  String? name;
  String? unit;
  String? logo;
  String? ticker;
  int? precision;
  int? blockchainFee;

  BlockchainData(
      {this.name,
        this.unit,
        this.logo,
        this.ticker,
        this.precision,
        this.blockchainFee});

  BlockchainData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    unit = json['unit'];
    logo = json['logo'];
    ticker = json['ticker'];
    precision = json['precision'];
    blockchainFee = json['blockchain_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['logo'] = this.logo;
    data['ticker'] = this.ticker;
    data['precision'] = this.precision;
    data['blockchain_fee'] = this.blockchainFee;
    return data;
  }
}
