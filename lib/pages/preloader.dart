import 'package:flutter/material.dart';
import 'package:fanava_payment/ui/cust_colors.dart';
class PreloaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: PColor.orangeparto,
    );
  }
}
