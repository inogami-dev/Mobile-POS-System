import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pos_system/core/widgets/my_audio_player.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/features/products/domain/delay_checker.dart';
import 'package:pos_system/features/products/presentation/state_management/single_scan_value.dart';

/// QR or Barcode is applicable
class MyScanner extends ConsumerStatefulWidget {
  /// For scanning multiple times
  final int millDelayPerScan;
  final bool isUsedToScanMultipleTimes;

  const MyScanner({
    super.key,
    this.isUsedToScanMultipleTimes = false,
    this.millDelayPerScan = 1000,
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
          ref
              .read(singleScanValueProvider.notifier)
              .setScannedValue(scannedBarcodes);
          myAudioPlayer.playLocalAudio("audios/bruhh_sound_effect.mp3");
          // myAudioPlayer.playLocalAudio("audios/shop_scan_sound_fx.mp3");

          iteration++;
          showMyAnimatedSnackBar(
            context: context,
            dataToDisplay: "$iteration: $scannedBarcodes",
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
