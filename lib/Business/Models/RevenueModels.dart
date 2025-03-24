class RevenueData {
  final int gross;
  final int net;
  final int concessionAmount;
  final int cancelAmount;

  RevenueData({
    required this.gross,
    required this.net,
    required this.concessionAmount,
    required this.cancelAmount,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      gross: json['GROSS'] ?? 0, // Default value is 0 if 'GROSS' is missing
      net: json['NET'] ?? 0, // Default value is 0 if 'NET' is missing
      concessionAmount: json['CONCESSION_AMOUNT'] ??
          0, // Default value is 0 if 'CONCESSION_AMOUNT' is missing
      cancelAmount: json['CANCEL_AMOUNT'] ??
          0, // Default value is 0 if 'CANCEL_AMOUNT' is missing
    );
  }
}

class ChannelDepartmentData {
  final int gross;
  final int net;
  final int concessionAmount;
  final int cancelAmount;
  final String? channelName;
  final int? channelID;
  final String? LocationNAme;

  ChannelDepartmentData({
    required this.gross,
    required this.net,
    required this.concessionAmount,
    required this.cancelAmount,
    required this.channelName,
    required this.channelID,
    required this.LocationNAme,
  });

  factory ChannelDepartmentData.fromJson(Map<String, dynamic> json) {
    return ChannelDepartmentData(
      gross: json['GROSS'] ?? 0, // Default value is 0 if 'GROSS' is missing
      net: json['NET'] ?? 0, // Default value is 0 if 'NET' is missing
      concessionAmount: json['CONCESSION_AMOUNT'] ??
          0, // Default value is 0 if 'CONCESSION_AMOUNT' is missing
      cancelAmount: json['CANCEL_AMOUNT'] ??
          0, // Default value is 0 if 'CANCEL_AMOUNT' is missing
      channelName: json['CHANNEL_NAME'],
      channelID: json['CHANNEL_ID'],
      LocationNAme: json['LOCATION_NAME'],
    );
  }
}
