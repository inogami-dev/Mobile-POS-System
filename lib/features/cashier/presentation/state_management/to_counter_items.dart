import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'to_counter_items.g.dart';

@Riverpod(keepAlive: true)
class ToCounterItems extends _$ToCounterItems {
  List<String> build() {
    return [];
  }

  void addProductToCounter(String productBarcode) {
    state = [...state, productBarcode];
    // state.add(productBarcode);
    log("Number of stored items: ${state.length}");
  }

  void removeAProductFromCounter(String productBarcode) {
    state = state.where((element) => element != productBarcode).toList();
  }
}
