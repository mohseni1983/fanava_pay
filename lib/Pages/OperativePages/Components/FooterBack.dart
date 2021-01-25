import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FooterBack extends StatelessWidget {
  FooterBack({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Pinned.fromSize(
          bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 62.0),
          size: Size(375.0, 62.0),
          pinLeft: true,
          pinRight: true,
          pinTop: true,
          pinBottom: true,
          child: SvgPicture.string(
            _svg_houo9n,
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

const String _svg_houo9n =
    '<svg viewBox="0.0 0.0 375.0 62.0" ><defs><filter id="shadow"><feDropShadow dx="0" dy="-2" stdDeviation="6"/></filter></defs><path transform="translate(2187.0, 2890.0)" d="M -2187 -2827.999755859375 L -2187 -2890 L -2044.746948242188 -2890 C -2046.241821289063 -2885.329833984375 -2047.000610351563 -2880.451904296875 -2047.000610351563 -2875.5 C -2047.000610351563 -2849.308349609375 -2025.692138671875 -2827.999755859375 -1999.500366210938 -2827.999755859375 C -1973.30859375 -2827.999755859375 -1952.000122070313 -2849.308349609375 -1952.000122070313 -2875.5 C -1952.000122070313 -2880.450927734375 -1952.7587890625 -2885.328857421875 -1954.253784179688 -2890 L -1812.000610351563 -2890 L -1812.000610351563 -2827.999755859375 L -2187 -2827.999755859375 Z" fill="#e07243" stroke="#26445d" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>';
