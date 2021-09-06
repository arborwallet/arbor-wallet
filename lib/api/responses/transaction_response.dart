
class TransactionResponse {
  TransactionResponse({
    required this.type,
    required this.timestamp,
    required this.block,
    this.destination,
    this.sender,
    required this.amount,
  });

  final String type;
  final int timestamp;
  final int block;
  final String? destination;
  final String? sender;
  final int amount;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => TransactionResponse(
    type: json["type"],
    timestamp: json["timestamp"],
    block: json["block"],
    destination: json["destination"] == null ? null : json["destination"],
    sender: json["sender"] == null ? null : json["sender"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "timestamp": timestamp,
    "block": block,
    "destination": destination == null ? null : destination,
    "sender": sender == null ? null : sender,
    "amount": amount,
  };
}