class CollectionData {
  final int gross;
  final int net;
  final int concessionAmount;
  final int cancelAmount;

  CollectionData({
    required this.gross,
    required this.net,
    required this.concessionAmount,
    required this.cancelAmount,
  });

  factory CollectionData.fromJson(Map<String, dynamic> json) {
    return CollectionData(
      gross: json['GROSS'] ?? 0, // Default value is 0 if 'GROSS' is missing
      net: json['NET'] ?? 0, // Default value is 0 if 'NET' is missing
      concessionAmount: json['CONCESSION_AMOUNT'] ??
          0, // Default value is 0 if 'CONCESSION_AMOUNT' is missing
      cancelAmount: json['CANCEL_AMOUNT'] ??
          0, // Default value is 0 if 'CANCEL_AMOUNT' is missing
    );
  }
}

class TransactionData {
  final int AMOUNT;
  final String? LOCATION_NAME;
  final int PAYMENT_MODE_ID;

  TransactionData({
    required this.AMOUNT,
    required this.LOCATION_NAME,
    required this.PAYMENT_MODE_ID,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      AMOUNT: json['AMOUNT'] ?? 0, // Default value is 0 if 'GROSS' is missing
      LOCATION_NAME:
          json['LOCATION_NAME'] ?? "", // Default value is 0 if 'NET' is missing
      PAYMENT_MODE_ID: json['PAYMENT_MODE_ID'] ??
          0, // Default value is 0 if 'CONCESSION_AMOUNT' is missing
    );
  }
}
