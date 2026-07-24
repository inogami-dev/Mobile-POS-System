import 'dart:developer';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'to_counter_items.g.dart';

@Riverpod(keepAlive: true)
class ToCounterItems extends _$ToCounterItems {
  @override
  List<ScannedItem> build() {
    return [];
  }

  void addProductToCounter(String productBarcode) {
    // 1. Check if the product ALREADY exists in the cart
    // Using indexWhere is much faster and cleaner than mapping manually.
    final existingIndex = state.indexWhere((item) => item.id == productBarcode);

    if (existingIndex != -1) {
      log("THE PRODUCT WAS ALREADY SCANNED..");

      // Get the existing item
      final existingItem = state[existingIndex];

      // Create a brand new copy of the item with updated quantity
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );

      // Create a BRAND NEW list for Riverpod to detect the change
      final newState = [...state];
      // Replace the old item with the new one
      newState[existingIndex] = updatedItem;

      state = newState; // Assign the new list to state!
    } else {
      log("THE PRODUCT WAS NOT YET SCANNED..");

      // 2. The item is NEW. Find it in the master inventory list.
      final inventoryItems = ref.read(allListedProductsProvider).value ?? [];

      // Find the specific product model
      // Uimple try/catch to safely look for the scanned product if it exist in the inventory.
      ProductModel? foundProduct;
      try {
        foundProduct = inventoryItems.firstWhere(
          (p) => p.barCode == productBarcode,
        );
      } catch (e) {
        log("Product with barcode $productBarcode not found in inventory!");
        return; // Exit if they scanned a barcode that doesn't exist in your system
      }

      // 3. Create the new ScannedItem
      final newItem = ScannedItem(
        id: foundProduct.barCode,
        name: foundProduct.name,
        quantity: 1,
        price: foundProduct.price.toDouble(),
      );

      // 4. Update the state with a BRAND NEW list using the spread operator
      state = [...state, newItem];
    }

    log("Number of stored items: ${state.length}");
  }

  void removeAProductFromCounter(String productBarcode) {
    // Instead of using .remove(), we just make a new list and ignore the specific element.
    state = state.where((element) => element.id != productBarcode).toList();
  }
}
