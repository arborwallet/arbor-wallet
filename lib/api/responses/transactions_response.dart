class TransactionListResponse {
  List<Transactions>? transactions;

  TransactionListResponse({this.transactions});

  TransactionListResponse.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = [];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? type;
  List<TransactionsResponse>? transactions;
  int? timestamp;
  int? block;
  int? amount;
  int? fee;

  Transactions(
      {this.type,
        this.transactions,
        this.timestamp,
        this.block,
        this.amount,
        this.fee});

  Transactions.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['transactions'] != null) {
      transactions =[];
      json['transactions'].forEach((v) {
        transactions!.add(new TransactionsResponse.fromJson(v));
      });
    }
    timestamp = json['timestamp'];
    block = json['block'];
    amount = json['amount'];
    fee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    data['timestamp'] = this.timestamp;
    data['block'] = this.block;
    data['amount'] = this.amount;
    data['fee'] = this.fee;
    return data;
  }
}

class TransactionsResponse {
  String? sender;
  String? destination;
  int? amount;

  TransactionsResponse({this.sender, this.amount});

  TransactionsResponse.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    destination = json['destination'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['destination']=this.destination;
    data['amount'] = this.amount;
    return data;
  }
}
