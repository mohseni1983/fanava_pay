// To parse this JSON data, do
//
//     final recipt = reciptFromJson(jsonString);

import 'dart:convert';

Recipt reciptFromJson(String str) => Recipt.fromJson(json.decode(str));

String reciptToJson(Recipt data) => json.encode(data.toJson());

class Recipt {
  Recipt({
    this.rrn,
    this.terminalId,
    this.invoiceId,
    this.amount,
    this.cardNumber,
    this.traceNumber,
    this.datePaid,
    this.respCode,
    this.respMsg,
    this.issuerBank,
    this.urlSchema,
  });

  String rrn;
  String terminalId;
  String invoiceId;
  String amount;
  String cardNumber;
  String traceNumber;
  DateTime datePaid;
  String respCode;
  String respMsg;
  String issuerBank;
  String urlSchema;

  factory Recipt.fromJson(Map<String, dynamic> json) => Recipt(
    rrn: json["Rrn"],
    terminalId: json["TerminalId"],
    invoiceId: json["InvoiceId"],
    amount: json["Amount"],
    cardNumber: json["CardNumber"],
    traceNumber: json["TraceNumber"],
    datePaid: DateTime.parse(json["DatePaid"]),
    respCode: json["RespCode"],
    respMsg: json["RespMsg"],
    issuerBank: json["IssuerBank"],
    urlSchema: json["UrlSchema"],
  );

  Map<String, dynamic> toJson() => {
    "Rrn": rrn,
    "TerminalId": terminalId,
    "InvoiceId": invoiceId,
    "Amount": amount,
    "CardNumber": cardNumber,
    "TraceNumber": traceNumber,
    "DatePaid": datePaid.toIso8601String(),
    "RespCode": respCode,
    "RespMsg": respMsg,
    "IssuerBank": issuerBank,
    "UrlSchema": urlSchema,
  };
}