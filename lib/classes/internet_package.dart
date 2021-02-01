import 'dart:convert';

class InternetPackageOperators{
  int id;
  String name;
  String grayImage;
  String colorImage;
  List<SimCardTypes> simTypes;

  InternetPackageOperators({this.id, this.name, this.grayImage, this.colorImage,this.simTypes});
}

class SimCardTypes{
  int id;
  String name;

  SimCardTypes({this.id, this.name});
}


InternetPackage internetPackageFromJson(String str) => InternetPackage.fromJson(json.decode(str));

String internetPackageToJson(InternetPackage data) => json.encode(data.toJson());

class InternetPackage {
  InternetPackage({
    this.amount,
    this.billGroup,
    this.canUseWallet,
    this.cash,
    this.dataPlans,
    this.deviceInfo,
    this.financingInfoList,
    this.responseCode,
    this.responseMessage,
    this.signKey,
    this.txnInfoList,
    this.url,
  });

  int amount;
  int billGroup;
  bool canUseWallet;
  int cash;
  List<DataPlan> dataPlans;
  dynamic deviceInfo;
  dynamic financingInfoList;
  int responseCode;
  String responseMessage;
  dynamic signKey;
  dynamic txnInfoList;
  dynamic url;

  factory InternetPackage.fromJson(Map<String, dynamic> json) => InternetPackage(
    amount: json["Amount"],
    billGroup: json["BillGroup"],
    canUseWallet: json["CanUseWallet"],
    cash: json["Cash"],
    dataPlans: List<DataPlan>.from(json["DataPlans"].map((x) => DataPlan.fromJson(x))),
    deviceInfo: json["DeviceInfo"],
    financingInfoList: json["FinancingInfoList"],
    responseCode: json["ResponseCode"],
    responseMessage: json["ResponseMessage"],
    signKey: json["SignKey"],
    txnInfoList: json["TxnInfoList"],
    url: json["Url"],
  );

  Map<String, dynamic> toJson() => {
    "Amount": amount,
    "BillGroup": billGroup,
    "CanUseWallet": canUseWallet,
    "Cash": cash,
    "DataPlans": List<dynamic>.from(dataPlans.map((x) => x.toJson())),
    "DeviceInfo": deviceInfo,
    "FinancingInfoList": financingInfoList,
    "ResponseCode": responseCode,
    "ResponseMessage": responseMessage,
    "SignKey": signKey,
    "TxnInfoList": txnInfoList,
    "Url": url,
  };
}

class DataPlan {
  DataPlan({
    this.dataPlanType,
    this.id,
    this.dataPlanOperator,
    this.period,
    this.priceWithTax,
    this.priceWithoutTax,
    this.profileId,
    this.title,
    this.uniqCode,
  });

  int dataPlanType;
  int id;
  int dataPlanOperator;
  int period;
  int priceWithTax;
  int priceWithoutTax;
  int profileId;
  String title;
  String uniqCode;

  factory DataPlan.fromJson(Map<String, dynamic> json) => DataPlan(
    dataPlanType: json["DataPlanType"],
    id: json["Id"],
    dataPlanOperator: json["Operator"],
    period: json["Period"],
    priceWithTax: json["PriceWithTax"],
    priceWithoutTax: json["PriceWithoutTax"],
    profileId: json["ProfileId"],
    title: json["Title"],
    uniqCode: json["UniqCode"],
  );

  Map<String, dynamic> toJson() => {
    "DataPlanType": dataPlanType,
    "Id": id,
    "Operator": dataPlanOperator,
    "Period": period,
    "PriceWithTax": priceWithTax,
    "PriceWithoutTax": priceWithoutTax,
    "ProfileId": profileId,
    "Title": title,
    "UniqCode": uniqCode,
  };
}
