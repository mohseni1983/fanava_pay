import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';

class HomeMasterBtn extends StatelessWidget {
  HomeMasterBtn({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 87.0, 87.0),
          size: Size(87.0, 87.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: const Color(0xff26445d),
              border: Border.all(width: 1.0, color: const Color(0xff26445d)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffe07243),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(17.0, 17.0, 54.0, 53.0),
          size: Size(87.0, 87.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child:
              // Adobe XD layer: 'home' (shape)
              Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/home.png'),
                fit: BoxFit.fill,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffe07243),
                  offset: Offset(0, 0),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
