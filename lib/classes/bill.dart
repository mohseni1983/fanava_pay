// To parse this JSON data, do
//
//     final bill = billFromJson(jsonString);

import 'dart:convert';

Bill billFromJson(String str) => Bill.fromJson(json.decode(str));

String billToJson(Bill data) => json.encode(data.toJson());

class Bill {
  Bill({
    this.amount,
    this.billGroup,
    this.bills,
    this.responseCode,
    this.responseMessage,
  });

  double amount;
  int billGroup;
  List<BillElement> bills;
  int responseCode;
  String responseMessage;

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    amount: json["Amount"],
    billGroup: json["BillGroup"],
    bills: List<BillElement>.from(json["Bills"].map((x) => BillElement.fromJson(x))),
    responseCode: json["ResponseCode"],
    responseMessage: json["ResponseMessage"],
  );

  Map<String, dynamic> toJson() => {
    "Amount": amount,
    "BillGroup": billGroup,
    "Bills": List<dynamic>.from(bills.map((x) => x.toJson())),
    "ResponseCode": responseCode,
    "ResponseMessage": responseMessage,
  };
}

class BillElement {
  BillElement({
    this.billType,
    this.billId,
    this.paymentId,
    this.amount,
  });

  int billType;
  String billId;
  String paymentId;
  String amount;

  factory BillElement.fromJson(Map<String, dynamic> json) => BillElement(
    billType: json["BillType"],
    billId: json["BillId"],
    paymentId: json["PaymentId"],
    amount: json["Amount"],
  );

  Map<String, dynamic> toJson() => {
    "BillType": billType,
    "BillId": billId,
    "PaymentId": paymentId,
    "Amount": amount,
  };
}
