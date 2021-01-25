import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import './FooterBtn.dart';
import 'package:flutter_svg/flutter_svg.dart';
import './FooterBack.dart';

class MainFooterOfApp extends StatelessWidget {
  MainFooterOfApp({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //Container(),
        FooterBack(),


/*
        Pinned.fromSize(
          bounds: Rect.fromLTWH(9.0, 35.6, 107.0, 55.4),
          size: Size(375.0, 91.0),
          pinLeft: true,
          pinBottom: true,
          fixedWidth: true,
          fixedHeight: true,
          child: GridView.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            children: [{}, {}].map((map) {
              return SizedBox(
                width: 40.0,
                height: 55.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(2.6, 0.0, 34.8, 34.8),
                      size: Size(40.0, 55.4),
                      pinLeft: true,
                      pinRight: true,
                      pinTop: true,
                      fixedHeight: true,
                      child:
                          // Adobe XD layer: 'FontAwsome (user-ci…' (shape)
                          SvgPicture.string(
                        _svg_sbcnwi,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(0.0, 33.4, 40.0, 22.0),
                      size: Size(40.0, 55.4),
                      pinLeft: true,
                      pinRight: true,
                      pinBottom: true,
                      fixedHeight: true,
                      child: Text(
                        'پروفایل',
                        style: TextStyle(
                          fontFamily: 'IRANSansWeb(FaNum)',
                          fontSize: 14,
                          color: const Color(0xff26445d),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Pinned.fromSize(
          bounds: Rect.fromLTWH(262.0, 35.6, 107.0, 55.4),
          size: Size(375.0, 91.0),
          pinRight: true,
          pinBottom: true,
          fixedWidth: true,
          fixedHeight: true,
          child: GridView.count(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            children: [{}, {}].map((map) {
              return SizedBox(
                width: 40.0,
                height: 55.0,
                child: Stack(
                  children: <Widget>[
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(2.6, 0.0, 34.8, 34.8),
                      size: Size(40.0, 55.4),
                      pinLeft: true,
                      pinRight: true,
                      pinTop: true,
                      fixedHeight: true,
                      child:
                          // Adobe XD layer: 'FontAwsome (user-ci…' (shape)
                          SvgPicture.string(
                        _svg_sbcnwi,
                        allowDrawingOutsideViewBox: true,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Pinned.fromSize(
                      bounds: Rect.fromLTWH(0.0, 33.4, 40.0, 22.0),
                      size: Size(40.0, 55.4),
                      pinLeft: true,
                      pinRight: true,
                      pinBottom: true,
                      fixedHeight: true,
                      child: Text(
                        'پروفایل',
                        style: TextStyle(
                          fontFamily: 'IRANSansWeb(FaNum)',
                          fontSize: 14,
                          color: const Color(0xff26445d),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
*/

      ],
    );
  }
}

const String _svg_sbcnwi =
    '<svg viewBox="2.6 0.0 34.8 34.8" ><path transform="translate(2.61, -8.0)" d="M 17.38494873046875 14.72965621948242 C 13.66961669921875 14.72965621948242 10.6552906036377 17.74398231506348 10.6552906036377 21.45931243896484 C 10.6552906036377 25.17464447021484 13.66961669921875 28.18897247314453 17.38494873046875 28.18897247314453 C 21.10028076171875 28.18897247314453 24.11460494995117 25.17464447021484 24.11460494995117 21.45931243896484 C 24.11460494995117 17.74398231506348 21.10028076171875 14.72965621948242 17.38494873046875 14.72965621948242 Z M 17.38494873046875 24.82414436340332 C 15.52728271484375 24.82414436340332 14.02011871337891 23.31698036193848 14.02011871337891 21.45931243896484 C 14.02011871337891 19.60164833068848 15.52728271484375 18.09448432922363 17.38494873046875 18.09448432922363 C 19.24261474609375 18.09448432922363 20.74977684020996 19.60164833068848 20.74977684020996 21.45931243896484 C 20.74977684020996 23.31698036193848 19.24261474609375 24.82414436340332 17.38494873046875 24.82414436340332 Z M 17.38494873046875 8 C 7.781166076660156 8 0 15.78116607666016 0 25.38494873046875 C 0 34.98873138427734 7.781166076660156 42.7698974609375 17.38494873046875 42.7698974609375 C 26.98873138427734 42.7698974609375 34.7698974609375 34.98873138427734 34.7698974609375 25.38494873046875 C 34.7698974609375 15.78116607666016 26.98873138427734 8 17.38494873046875 8 Z M 17.38494873046875 39.40506744384766 C 13.90094947814941 39.40506744384766 10.71838092803955 38.12222671508789 8.264860153198242 36.01219940185547 C 9.309358596801758 34.39988327026367 11.096923828125 33.30631637573242 13.14386177062988 33.24322891235352 C 14.60195446014404 33.69187164306641 15.98994731903076 33.91619110107422 17.38494873046875 33.91619110107422 C 18.77994918823242 33.91619110107422 20.16794204711914 33.69887924194336 21.62603378295898 33.24322891235352 C 23.67297172546387 33.31332397460938 25.46053886413574 34.39988327026367 26.50503540039063 36.01219940185547 C 24.051513671875 38.12222671508789 20.86894798278809 39.40506744384766 17.38494873046875 39.40506744384766 Z M 28.79031753540039 33.50960922241211 C 27.07986259460449 31.30844879150391 24.43707084655762 29.87138748168945 21.42274284362793 29.87138748168945 C 20.70771598815918 29.87138748168945 19.60012626647949 30.54435348510742 17.38494873046875 30.54435348510742 C 15.17677974700928 30.54435348510742 14.06217956542969 29.87138748168945 13.34715366363525 29.87138748168945 C 10.3398380279541 29.87138748168945 7.69704532623291 31.30844879150391 5.979580402374268 33.50960922241211 C 4.339227199554443 31.21731948852539 3.364828586578369 28.41329574584961 3.364828586578369 25.38494873046875 C 3.364828586578369 17.65285110473633 9.652852058410645 11.36482810974121 17.38494873046875 11.36482810974121 C 25.11704254150391 11.36482810974121 31.40506553649902 17.65285110473633 31.40506553649902 25.38494873046875 C 31.40506553649902 28.41329574584961 30.4306697845459 31.21731948852539 28.79031753540039 33.50960922241211 Z" fill="#e9e9e9" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_houo9n =
    '<svg viewBox="0.0 0.0 375.0 62.0" ><defs><filter id="shadow"><feDropShadow dx="0" dy="-2" stdDeviation="6"/></filter></defs><path transform="translate(2187.0, 2890.0)" d="M -2187 -2827.999755859375 L -2187 -2890 L -2044.746948242188 -2890 C -2046.241821289063 -2885.329833984375 -2047.000610351563 -2880.451904296875 -2047.000610351563 -2875.5 C -2047.000610351563 -2849.308349609375 -2025.692138671875 -2827.999755859375 -1999.500366210938 -2827.999755859375 C -1973.30859375 -2827.999755859375 -1952.000122070313 -2849.308349609375 -1952.000122070313 -2875.5 C -1952.000122070313 -2880.450927734375 -1952.7587890625 -2885.328857421875 -1954.253784179688 -2890 L -1812.000610351563 -2890 L -1812.000610351563 -2827.999755859375 L -2187 -2827.999755859375 Z" fill="#e07243" stroke="#26445d" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>';
