import 'package:flutter/material.dart';
import 'package:parto_v/classes/convert.dart';
import 'package:parto_v/ui/cust_colors.dart';

class CSelectedPackage extends StatefulWidget {
  final double height;
  final String  label;
  final Color selectedColor;
  final Color color;
  final Color textColor;
  final Color selectedTextColor;
  final int value;
  final Function(int tval) onPress;
  final int selectedValue;
  final double costWithTax;
  final double costWithoutTax;
  
  const CSelectedPackage({Key key, this.height=50,  this.selectedColor=PColor.blueparto,
    this.color=PColor.orangeparto,  this.label,this.value=-1,
    this.textColor=PColor.blueparto,this.selectedTextColor=Colors.white,
    this.onPress,
    this.selectedValue,
    this.costWithoutTax,
    this.costWithTax
    
  }) : super(key: key);

  @override
  _CSelectedPackageState createState() => _CSelectedPackageState();
}

class _CSelectedPackageState extends State<CSelectedPackage> {
  @override
  Widget build(BuildContext context) {
    return    GestureDetector(
      child:
      Container(
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius:BorderRadius.circular(8) ,
            color: widget.selectedValue==widget.value?PColor.orangeparto:PColor.orangepartoAccent
        ),
        child:
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
             // mainAxisAlignment: MainAxisAlignment.start,
              //mainAxisSize: MainAxisSize.max,
              children: [
                Text(widget.label,style: TextStyle(color: PColor.blueparto,fontSize: widget.label.length>70?10:12,fontWeight: FontWeight.bold),textAlign: TextAlign.start,softWrap: true,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('قیمت بدون مالیات: ${getMoneyByRial(widget.costWithoutTax.toInt())}ریال',style: TextStyle(fontSize: 10),),
                    Padding(padding: EdgeInsets.only(left: 8)),
                    Text('قیمت با مالیات: ${getMoneyByRial(widget.costWithTax.toInt())}ریال',style: TextStyle(fontSize: 10),)

                  ],
                )

              ],
            )
          ],
        )
        ,
      ),
      onTap: (){
        setState(() {
          widget.onPress(widget.value);
        });
      },

    );

  }
}
