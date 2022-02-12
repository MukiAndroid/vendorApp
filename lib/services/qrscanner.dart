import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      secondPageRoute();
    });
  }

  bool flash = false;
  secondPageRoute() async {
    controller?.pauseCamera();
    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text(
            "Scan to verify",
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.info_outline_rounded)),
          ],
        ),
        body: SafeArea(
          child: QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Theme.of(context).colorScheme.secondary),
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: kPrimaryColor,
            onPressed: () {
              controller.toggleFlash().then((value) {
                controller.getFlashStatus.call().then((val) {
                  setState(() {
                    flash = val;
                  });
                });
              });
            },
            label: flash
                ? const Icon(Icons.flash_off)
                : const Icon(Icons.flash_on)));
  }
}
