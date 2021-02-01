class AcountTransTxnInfoList {
  AcountTransTxnInfoList({
    this.totalCounts,
    this.txnInfoLists,
  });

  int totalCounts;
  List<TxnInfoListElement> txnInfoLists;

  factory AcountTransTxnInfoList.fromJson(Map<String, dynamic> json) => AcountTransTxnInfoList(
    totalCounts: json["TotalCounts"],
    txnInfoLists: List<TxnInfoListElement>.from(json["TxnInfoLists"].map((x) => TxnInfoListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "TotalCounts": totalCounts,
    "TxnInfoLists": List<dynamic>.from(txnInfoLists.map((x) => x.toJson())),
  };
}

class TxnInfoListElement {
  TxnInfoListElement({
    this.amount,
    this.billGroup,
    this.billId,
    this.cardNumber,
    this.cellNumber,
    this.isCharge,
    this.isReverse,
    this.isSettle,
    this.issuerBank,
    this.payId,
    this.requestDate,
    this.requestType,
    this.requestTypeDetails,
    this.rrn,
    this.traceNumber,
  });

  double amount;
  int billGroup;
  String billId;
  String cardNumber;
  String cellNumber;
  bool isCharge;
  bool isReverse;
  bool isSettle;
  String issuerBank;
  String payId;
  String requestDate;
  int requestType;
  String requestTypeDetails;
  String rrn;
  String traceNumber;

  factory TxnInfoListElement.fromJson(Map<String, dynamic> json) => TxnInfoListElement(
    amount: json["Amount"],
    billGroup: json["BillGroup"],
    billId: json["BillId"],
    cardNumber: json["CardNumber"] == null ? null : json["CardNumber"],
    cellNumber: json["CellNumber"],
    isCharge: json["IsCharge"],
    isReverse: json["IsReverse"],
    isSettle: json["IsSettle"],
    issuerBank: json["IssuerBank"] == null ? null : json["IssuerBank"],
    payId: json["PayId"],
    requestDate: json["RequestDate"],
    requestType: json["RequestType"],
    requestTypeDetails: json["RequestTypeDetails"],
    rrn: json["Rrn"] == null ? null : json["Rrn"],
    traceNumber: json["TraceNumber"] == null ? null : json["TraceNumber"],
  );

  Map<String, dynamic> toJson() => {
    "Amount": amount,
    "BillGroup": billGroup,
    "BillId": billId,
    "CardNumber": cardNumber == null ? null : cardNumber,
    "CellNumber": cellNumber,
    "IsCharge": isCharge,
    "IsReverse": isReverse,
    "IsSettle": isSettle,
    "IssuerBank": issuerBank == null ? null : issuerBank,
    "PayId": payId,
    "RequestDate": requestDate,
    "RequestType": requestType,
    "RequestTypeDetails": requestTypeDetails,
    "Rrn": rrn == null ? null : rrn,
    "TraceNumber": traceNumber == null ? null : traceNumber,
  };
}