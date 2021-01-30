import 'package:flutter_money_formatter/flutter_money_formatter.dart';


String getMoneyByRial(int amount){
return FlutterMoneyFormatter(amount: amount.toDouble(),settings: MoneyFormatterSettings(
  thousandSeparator: ',',
  compactFormatType: CompactFormatType.short,
  symbol: 'ریال',
  fractionDigits: 0,
  symbolAndNumberSeparator: ' '
)).output.nonSymbol;
}

