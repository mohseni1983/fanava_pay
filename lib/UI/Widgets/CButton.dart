import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../Colors.dart';
class CButton extends StatefulWidget {
  final VoidCallback onClick;
  final String label;
  final double minWidth;

  const CButton({Key key, this.onClick,this.label,this.minWidth}) : super(key: key);
  @override
  _CButtonState createState() => _CButtonState();
}

class _CButtonState extends State<CButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      animationDuration: Duration(seconds: 1),
        color: PColor.blueparto,
        height: 45,
        minWidth: widget.minWidth,
        splashColor: PColor.orangeparto,
        elevation: 2,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            //side: BorderSide(color: Colors.red)
        ),
        //textTheme: ButtonTextTheme.primary,
        child: Text(widget.label,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 18),),
        onPressed: widget.onClick);
  }
}
