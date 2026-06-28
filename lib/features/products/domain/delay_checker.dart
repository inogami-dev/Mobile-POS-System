import 'dart:developer';

/// [millDelayPerScan] indicates the set time delay in milliseconds
/// [lastTimeScanned] indicates the last successful scan time
bool isPastTheSetTimeDelay({
  required int millDelayPerScan,
  required DateTime? lastTimeScanned,
}) {
  // First scan
  if (lastTimeScanned == null) {
    return true;
  }

  final difference = DateTime.now().difference(lastTimeScanned);

  if (difference > Duration(milliseconds: millDelayPerScan)) {
    return true;
  } else {
    log(difference.toString());
  }

  return false;
}
