import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/features/products/domain/delay_checker.dart';

/// QR or Barcode is applicable
class MyScanner extends StatefulWidget {
  /// For scanning multiple times
  final int millDelayPerScan;
  final bool isUsedToScanMultipleTimes;

  const MyScanner({
    super.key,
    this.isUsedToScanMultipleTimes = false,
    this.millDelayPerScan = 1000,
  });

  @override
  State<MyScanner> createState() => _MyScannerState();
}

class _MyScannerState extends State<MyScanner> {
  // late BarcodeCapture barcodes;
  late String scannedBarcodes;
  int iteration = 0;
  DateTime lastTimeScanned = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (barcodes) {
        if (isPastTheSetTimeDelay(
          millDelayPerScan: widget.millDelayPerScan,
          lastTimeScanned: lastTimeScanned,
        )) {
          scannedBarcodes = barcodes.barcodes.first.rawValue!;
          iteration++;
          lastTimeScanned = DateTime.now();

          showMyAnimatedSnackBar(
            context: context,
            dataToDisplay: "$iteration: $scannedBarcodes",
          );
        }

        // Exit na pag nakascan nag kaisa
        if (!widget.isUsedToScanMultipleTimes && scannedBarcodes.isNotEmpty) {
          Navigator.pop(context);
        }
      },
    );
  }
}
