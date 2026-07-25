import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'to_checkout.g.dart';

@riverpod
class ToCheckout extends _$ToCheckout {
  @override
  bool build() => false;

  void toggle([bool? newValue]) {
    state = newValue ?? !state;
    log(state.toString());
  }
}
