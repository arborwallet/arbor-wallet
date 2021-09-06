class KeygenResponse {
  final bool success;
  final String phrase;
  final String privateKey;
  final String publicKey;

  KeygenResponse({
    required this.success,
    required this.phrase,
    required this.privateKey,
    required this.publicKey,
  });

  factory KeygenResponse.fromJson(Map<String, dynamic> json) {
    return KeygenResponse(
      success: json['success'],
      phrase: json['phrase'],
      privateKey: json['private_key'],
      publicKey: json['public_key'],
    );
  }
}