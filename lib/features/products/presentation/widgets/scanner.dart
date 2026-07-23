import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_system/core/widgets/my_audio_player.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/domain/delay_checker.dart';
import 'package:pos_system/features/products/presentation/state_management/single_scan_value.dart';

/// QR or Barcode is applicable
class MyScanner extends ConsumerStatefulWidget {
  /// For scanning multiple times
  final int millDelayPerScan;
  final bool isUsedToScanMultipleTimes;
  final double? snackbarMovingDistance;
  final String productName;

  const MyScanner({
    super.key,
    this.isUsedToScanMultipleTimes = false,
    this.millDelayPerScan = 1000,
    this.snackbarMovingDistance,
    this.productName = "Product",
  });

  @override
  ConsumerState<MyScanner> createState() => _MyScannerState();
}

class _MyScannerState extends ConsumerState<MyScanner> {
  /// Object Fields
  late MyAudioPlayer myAudioPlayer;

  // late BarcodeCapture barcodes;
  String scannedBarcodes = "";
  int iteration = 0; // for testing only (deletable)
  DateTime lastTimeScanned = DateTime.now();

  @override
  void initState() {
    super.initState();
    myAudioPlayer = MyAudioPlayer(player: AudioPlayer());
  }

  @override
  void dispose() {
    myAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      onDetect: (barcodes) {
        // Stream
        if (isPastTheSetTimeDelay(
          millDelayPerScan: widget.millDelayPerScan,
          lastTimeScanned: lastTimeScanned,
        )) {
          scannedBarcodes = barcodes.barcodes.first.rawValue!;
          lastTimeScanned = DateTime.now();

          if (widget.isUsedToScanMultipleTimes) {
            ref
                .read(toCounterItemsProvider.notifier)
                .addProductToCounter(scannedBarcodes);
            log(
              "Scanned Items [${ref.read(toCounterItemsProvider).length}]: ${ref.read(toCounterItemsProvider)}",
            );
          } else {
            ref
                .read(singleScanValueProvider.notifier)
                .setScannedValue(scannedBarcodes);
            log("Scanner was used as a single scanner only");
          }
          // myAudioPlayer.playLocalAudio("audios/bruhh_sound_effect.mp3");
          myAudioPlayer.playLocalAudio("audios/shop_scan_sound_fx.mp3");

          iteration++;
          // showMyAnimatedSnackBar(
          //   context: context,
          //   dataToDisplay: "$iteration: $scannedBarcodes",
          //   movingDistance: widget.snackbarMovingDistance,
          // );
          showMyAnimatedSnackBar(
            context: context,
            // dataToDisplay: "Scanned: ${widget.productName}",
            dataToDisplay:
                "Scanned: ${ref.watch(allListedProductsProvider.notifier).getProduct(scannedBarcodes)?.name}",
            movingDistance: widget.snackbarMovingDistance,
          );

          // Exit na pag nakascan nag kaisa
          if (!widget.isUsedToScanMultipleTimes && scannedBarcodes.isNotEmpty) {
            // The delay is based on the sound length
            Future.delayed(Duration(milliseconds: 650), () {
              Navigator.pop(context);
            });
          }
        }
      },
    );
  }
}
