import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/state_management/product_repo_ref_controller.dart';

void saveProductLogic(
  BuildContext context, {
  required WidgetRef ref,
  required String productName,
  required String productDescription,
  required String productPrice,
  required String productQuantity,
  required String? expirationDate,
  required String scannedBarcode,
  required String pickedProductImage,
}) {
  return myAlertDialogue(
    context: context,
    alertTitle: "Confirmation to Save Product?",
    alertContent:
        "You are about to save this product, only proceed if you have fill out all the details in the form.",
    onApprovalPressed: () async {
      final currentlyLoggedInUser = ref
          .read(currentLoggedInUserControllerProvider)
          .valueOrNull;
      if (currentlyLoggedInUser == null) {
        showMyAnimatedSnackBar(
          context: context,
          dataToDisplay: "Could not retrieve user info. Please check your connection.",
        );
        return;
      }
      final storeID = currentlyLoggedInUser.currentStoreInView;
      final productRepoRef = ref.read(productRepositoryProvider(storeID));

      final newProduct = ProductModel(
        name: productName.trim(),
        queryName: productName.trim().toLowerCase(),
        storeId: storeID,
        description: productDescription.trim(),
        barCode: scannedBarcode,
        price: double.parse(productPrice.trim()),
        quantity: int.parse(productQuantity.trim()),
        picture: pickedProductImage,
        expirationDate: (expirationDate == null)
            ? ""
            : expirationDate, // no expiry
        registeredOn: DateTime.now().toString(),
        registeredBy: currentlyLoggedInUser.id!,
      );

      // Add the product to the database
      await productRepoRef.add(newProduct);
      // Fetch the newly added product from the database
      final fetchedNewlyAddedProduct = await productRepoRef.getByQuery(
        field: "registeredOn",
        value: newProduct.registeredOn,
      );
      // Add the newly added product to the cached list
      ref
          .read(allListedProductsProvider.notifier)
          .addNewProductToTheList(fetchedNewlyAddedProduct.first);

      showMyAnimatedSnackBar(
        context: context,
        dataToDisplay:
            "Name: ${productName} \nDescription: ${productDescription} \nPrice: ${productPrice} \nExpiration Date: ${expirationDate.toString()}",
      );

      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
}
