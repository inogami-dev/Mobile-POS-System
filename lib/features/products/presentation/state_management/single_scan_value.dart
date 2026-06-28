import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'single_scan_value.g.dart';

@riverpod
class SingleScanValue extends _$SingleScanValue {
  @override
  String build() => "";

  void setScannedValue(String value) {
    state = value;
  }

  void resetScannedValue() {
    state = "";
  }
}
