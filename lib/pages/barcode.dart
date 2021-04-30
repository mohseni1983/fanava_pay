import 'package:camerakit/CameraKitController.dart';
import 'package:camerakit/CameraKitView.dart';
import 'package:flutter/material.dart';
import 'package:camerakit/camerakit.dart';
import 'package:parto_v/custom_widgets/cust_alert_dialog.dart';
import 'package:parto_v/custom_widgets/cust_button.dart';
class BarcodeScanner extends StatelessWidget {
  CameraKitView cameraKitView;
  CameraFlashMode _flashMode = CameraFlashMode.on;
  CameraKitController cameraKitController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CButton(
                    label: 'بستن',
                    onClick: ()=>Navigator.pop(context,'no barcode'),
                  )
                ],

          )),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CameraKitView(
              hasBarcodeReader: true,
              barcodeFormat: BarcodeFormats.FORMAT_ALL_FORMATS,
              androidCameraMode: AndroidCameraMode.API_X,
              cameraKitController: cameraKitController,
              cameraSelector: CameraSelector.back,
              onPermissionDenied: (){
                showDialog(context: context,
                  builder: (context) => CAlertDialog(
                    content: 'خطا در دوربین',
                    subContent: 'اپلیکیشن اجازه دسترسی به دوربین را ندارد',
                    buttons: [
                      CButton(
                        label: 'بستن',
                        onClick: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              },
              onBarcodeRead: (barcode){
                Navigator.pop(context,barcode);
              },

            ),
          )
        ],
      ),
    );
  }
}
