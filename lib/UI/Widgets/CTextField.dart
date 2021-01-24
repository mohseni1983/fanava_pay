import 'package:flutter/material.dart';

import '../Colors.dart';
class CTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextAlign textAlign;

  const CTextField({Key key, this.controller,this.textAlign}) : super(key: key);
  @override
  _CTextFieldState createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
  @override
  Widget build(BuildContext context) {
    return
      Material(
        shadowColor: PColor.blueparto,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        elevation: 5.0,
        child: TextField(
          controller: widget.controller,
          textAlign: widget.textAlign,
        ),
      );

  }
}
