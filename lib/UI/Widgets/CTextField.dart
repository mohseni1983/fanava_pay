import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Colors.dart';
class CTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextAlign textAlign;
  final int maxLenght;
  final TextInputType keyboardType;

  const CTextField({Key key, this.controller,this.textAlign,this.maxLenght=50,this.keyboardType=TextInputType.text}) : super(key: key);
  @override
  _CTextFieldState createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
  @override
  Widget build(BuildContext context) {
    return
      TextField(
        decoration: InputDecoration(
            counter: Offstage(),
            counterText: ''
        ),

        controller: widget.controller,
        textAlign: widget.textAlign,
        maxLength: widget.maxLenght,
        keyboardType: widget.keyboardType,
      );


  }
}
