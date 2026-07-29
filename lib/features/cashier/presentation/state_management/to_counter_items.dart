import 'dart:developer';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/state_management/product_repo_ref_controller.dart';
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
      log("THE PRODUCT WAS ALREADY SCANNED BEFORE..");

      // Get the existing item
      final existingItem = state[existingIndex];

      // // If the inventory count of this item is 0 or will go below 0, prevent adding it into the counter.
      // if (existingItem.quantity <= 0) log("aaaaaaaaaaaaaaa");

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
      log("THE PRODUCT WAS NOT YET SCANNED BEFORE..");

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
        return;
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

  void editAProductQuantity({
    required String barcode,
    required double quantity,
  }) {
    final newState = state;
    final existingIndex = state.indexWhere((item) => item.id == barcode);

    try {
      newState[existingIndex] = newState[existingIndex].copyWith(
        quantity: quantity,
      );
      state = [...newState];
    } catch (e, stackTrace) {
      log(
        "There is an error on editAProductQuantity method in ToCounterItems state (to_counter_items.dart) \nThe Error is $e at $stackTrace",
      );
    }
  }

  ScannedItem getAnItem(String barcode) {
    return state.firstWhere((element) => element.id == barcode);
  }

  Future<void> checkoutCompletion(List<ScannedItem> items) async {
    String storeID = ref
        .read(currentLoggedInUserControllerProvider)
        .value!
        .currentStoreInView;
    log("Store ID: ${storeID}");

    for (var item in items) {
      log("Processing: ${item.name}");
      ProductModel product = ref
          .read(allListedProductsProvider.notifier)
          .getProduct(item.id!)!;
      // Deduct the quantity from the database
      ref
          .read(productRepositoryProvider(storeID))
          .update(
            product.id!,
            product.copyWith(
              quantity: product.quantity - item.quantity.toInt(),
            ),
          );
      // Deduct the quantity from the inventory
      ref
          .read(allListedProductsProvider.notifier)
          .updateProduct(
            product.copyWith(
              quantity: product.quantity - item.quantity.toInt(),
            ),
          );
      // Clear the counter
      state = [];
      log("Success: ${item.name}");
    }
  }

  void removeAProductFromCounter(String productBarcode) {
    // Instead of using .remove(), we just make a new list and ignore the specific element.
    state = state.where((element) => element.id != productBarcode).toList();
  }

  void abortTransaction() {
    state = [];
  }
}
