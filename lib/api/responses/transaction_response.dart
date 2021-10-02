class TransactionsResponse {
  TransactionsResponse({
    this.destination,
    this.sender,
    required this.amount,
  });

  final String? destination;
  final String? sender;
  final int amount;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) => TransactionsResponse(
    destination: json["destination"] == null ? null : json["destination"],
    sender: json["sender"] == null ? null : json["sender"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "destination": destination == null ? null : destination,
    "sender": sender == null ? null : sender,
    "amount": amount,
  };
}

