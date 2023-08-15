import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:jee_library/services/analytics_consts.dart';
import 'package:jee_library/widgets/barcodeOverlay.dart';
import 'package:jee_library/services/consts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanner extends StatelessWidget {

  const BarcodeScanner({super.key});

  Future<bool> checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    checkConnection().then((value) {
      if (!value) {
        FirebaseAnalytics.instance.logEvent(name: "scan_attempt", parameters: {"status": ScanAttemptStatus.noInternet.name, "id": ""});
        Navigator.of(context).pop(codeNoInternet);
      } else {
        setCurrentScreen(ScreenName.scanner);
      }
    });
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          title: const Text('Scan')
      ),
      body: Stack(
        children: [
          MobileScanner(
            // fit: BoxFit.contain,
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              detectionTimeoutMs: 500,
              facing: CameraFacing.back,
              torchEnabled: false,
            ),
            onDetect: (capture) {
              final String? barcode = capture.barcodes[0].rawValue?.substring(0, 12);
              final Uint8List? image = capture.image;
              Navigator.of(context).pop(barcode);
            },
          ),
          const BarcodeScannerOverlay(overlayColour: Color.fromRGBO(0, 0, 0, 0.5)),
        ],
      ),
    );
  }
}
