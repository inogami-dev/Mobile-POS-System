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
          .value!;
      final storeID = currentlyLoggedInUser.currentStoreInView;
      final productRepoRef = ref.read(productRepositoryProvider(storeID));

      productRepoRef.add(
        ProductModel(
          name: productName.trim(),
          queryName: productName.trim().toLowerCase(),
          storeId: storeID,
          description: productDescription.trim(),
          barCode: scannedBarcode,
          price: double.parse(productPrice.trim()),
          quantity: int.parse(productQuantity.trim()),
          picture: pickedProductImage,
          expirationDate: expirationDate?.toString() ?? "", // no expiry
          registeredOn: DateTime.now().toString(),
          registeredBy: currentlyLoggedInUser.id!,
        ),
      );
      showMyAnimatedSnackBar(
        context: context,
        dataToDisplay:
            "Name: ${productName} \nDescription: ${productDescription} \nPrice: ${productPrice} \nExpiration Date: ${expirationDate.toString()}",
      );
      Future.microtask(() {
        ref.invalidate(allListedProductsProvider);
      });

      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
}
