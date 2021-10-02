import 'blockchain_response.dart';

class WalletResponse {
  WalletResponse({
    required this.success,
    required this.address,
    required this.fork,
  });

  final bool success;
  final String address;
  final BlockchainResponse fork;

  factory WalletResponse.fromJson(Map<String, dynamic> json) => WalletResponse(
    success: json["success"],
    address: json["address"],
    fork: BlockchainResponse.fromJson(json["fork"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "address": address,
    "fork": fork.toJson(),
  };
}