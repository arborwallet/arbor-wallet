class ForkResponse {
  Fork? fork;

  ForkResponse({this.fork});

  ForkResponse.fromJson(Map<String, dynamic> json) {
    fork = json['fork'] != null ? new Fork.fromJson(json['fork']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fork != null) {
      data['fork'] = this.fork!.toJson();
    }
    return data;
  }
}

class Fork {
  String? name;
  String? unit;
  String? logo;
  String? ticker;
  int? precision;
  int? networkFee;

  Fork(
      {this.name,
        this.unit,
        this.logo,
        this.ticker,
        this.precision,
        this.networkFee});

  Fork.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    unit = json['unit'];
    logo = json['logo'];
    ticker = json['ticker'];
    precision = json['precision'];
    networkFee = json['network_fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['unit'] = this.unit;
    data['logo'] = this.logo;
    data['ticker'] = this.ticker;
    data['precision'] = this.precision;
    data['network_fee'] = this.networkFee;
    return data;
  }
}
