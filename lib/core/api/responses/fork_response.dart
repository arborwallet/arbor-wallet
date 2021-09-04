class ForkResponse {
  ForkResponse({
    required this.name,
    required this.ticker,
    required this.unit,
    required this.precision,
  });

  final String name;
  final String ticker;
  final String unit;
  final int precision;

  factory ForkResponse.fromJson(Map<String, dynamic> json) => ForkResponse(
    name: json['name'],
    ticker: json['ticker'],
    unit: json['unit'],
    precision: json['precision'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'ticker': ticker,
    'unit': unit,
    'precision': precision,
  };
}