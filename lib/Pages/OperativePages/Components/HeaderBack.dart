import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeaderBack extends StatelessWidget {
  HeaderBack({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 200.0),
          size: Size(375.0, 200.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child: SvgPicture.string(
            _svg_mq30wu,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 200.0),
          size: Size(375.0, 200.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child: SvgPicture.string(
            _svg_2rup1j,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 200.0),
          size: Size(375.0, 200.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child: SvgPicture.string(
            _svg_30ph6e,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 200.0),
          size: Size(375.0, 200.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child: SvgPicture.string(
            _svg_jyq2pk,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

const String _svg_mq30wu =
    '<svg viewBox="0.0 0.0 375.0 200.0" ><path transform="translate(1903.0, 2890.0)" d="M -1902.700317382813 -2690.000244140625 L -1902.700561523438 -2690.000244140625 L -1902.999633789063 -2690.000244140625 L -1902.999633789063 -2890 L -1528.000244140625 -2890 L -1528.000244140625 -2690.29638671875 C -1587.228271484375 -2715.314453125 -1650.143798828125 -2728 -1715.00048828125 -2728 C -1780.109130859375 -2728 -1843.260375976563 -2715.215087890625 -1902.7001953125 -2690.000244140625 L -1902.700317382813 -2690.000244140625 L -1902.700561523438 -2690.000244140625 L -1902.700317382813 -2690.000244140625 Z" fill="#e07243" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_2rup1j =
    '<svg viewBox="0.0 0.0 375.0 200.0" ><path transform="translate(2133.0, 2890.0)" d="M -1758.30029296875 -2690.000244140625 L -1758.30029296875 -2690.29638671875 C -1817.527587890625 -2715.314453125 -1880.44384765625 -2728 -1945.300537109375 -2728 C -2010.409301757813 -2728 -2073.560546875 -2715.215576171875 -2133 -2690.000244140625 L -2133 -2740.299560546875 L -1945.500366210938 -2890 L -1757.999755859375 -2740.29931640625 L -1757.999755859375 -2690.000244140625 L -1758.30029296875 -2690.000244140625 Z" fill="#ffffff" fill-opacity="0.2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_30ph6e =
    '<svg viewBox="0.0 0.0 375.0 200.0" ><path transform="translate(2100.0, 2890.0)" d="M -2099.999755859375 -2690.000244140625 L -2099.999755859375 -2757.60595703125 L -1911.999633789063 -2890 L -1725.000366210938 -2758.310302734375 L -1725.000366210938 -2690.29638671875 C -1784.228393554688 -2715.314453125 -1847.144775390625 -2728 -1912.00048828125 -2728 C -1977.109252929688 -2728 -2040.260498046875 -2715.215576171875 -2099.699951171875 -2690.000244140625 L -2099.999755859375 -2690.000244140625 Z" fill="#ffffff" fill-opacity="0.2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_jyq2pk =
    '<svg viewBox="0.0 0.0 375.0 200.0" ><path transform="translate(2196.0, 2890.0)" d="M -1820.998168945313 -2689.99853515625 L -1821.00048828125 -2689.99853515625 L -1821.30029296875 -2690.000244140625 L -1821.30029296875 -2690.29638671875 C -1880.52783203125 -2715.314208984375 -1943.443969726563 -2728 -2008.300537109375 -2728 C -2073.408935546875 -2728 -2136.56005859375 -2715.215087890625 -2196 -2690.000244140625 L -2008.500366210938 -2890 L -1820.999755859375 -2690.000244140625 L -1820.998168945313 -2689.99853515625 Z" fill="#e9e9e9" fill-opacity="0.2" stroke="none" stroke-width="1" stroke-opacity="0.2" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';