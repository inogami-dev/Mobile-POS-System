import 'dart:developer';

import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/state_management/product_repo_ref_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_listed_products.g.dart';

@Riverpod()
class AllListedProducts extends _$AllListedProducts {
  @override
  Future<List<ProductModel>> build() async {
    final user = ref.watch(currentLoggedInUserControllerProvider).valueOrNull;
    if (user == null) return [];
    final currentSelectedStoreID = user.currentStoreInView;

    final productRepository = ref.watch(
      productRepositoryProvider(currentSelectedStoreID),
    );
    final products = await productRepository.getAllRecords();
    products.sort((a, b) => a.queryName.compareTo(b.queryName));
    return products;
  }

  void addNewProductToTheList(ProductModel newProduct) {
    List<ProductModel> currentProductList = state.value ?? [];

    final updatedProductList = [...currentProductList, newProduct];
    updatedProductList.sort((a, b) => a.queryName.compareTo(b.queryName));

    state = AsyncValue.data(updatedProductList);

    log("New Product Added to the Cached List: ${newProduct.name}");
  }

  void removeProductFromTheList(ProductModel product) {
    List<ProductModel> tempProductList = state.value!;
    tempProductList.removeWhere((testProduct) {
      if (testProduct.id == product.id) {
        return true;
      }
      return false;
    });
    tempProductList.sort((a, b) => a.queryName.compareTo(b.queryName));
    state = AsyncValue.data(tempProductList);

    log("Product Removed from the Cached List: ${product.name}");
    // }
  }

  ProductModel? getProduct(String barcode) {
    try {
      return state.value!.firstWhere((product) => product.barCode == barcode);
    } catch (e) {
      return null;
    }
  }

  void updateProduct(ProductModel updatedProduct) {
    log("This is executed 1");
    List<ProductModel> newState = state.value!;
    int productToChangeIndex = newState.indexWhere(
      (product) => product.barCode == updatedProduct.barCode,
    );
    log("This is executed 2");

    newState[productToChangeIndex] = updatedProduct;
    newState.sort((a, b) => a.queryName.compareTo(b.queryName));
    state = AsyncValue.data(newState);
    log("Product Updated: ${updatedProduct.name}");
  }
}
