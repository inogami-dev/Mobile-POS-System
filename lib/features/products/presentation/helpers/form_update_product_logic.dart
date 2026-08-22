import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/state_management/product_repo_ref_controller.dart';

Future<void> updateProductLogic(
  BuildContext context, {
  required WidgetRef ref,
  required ProductModel product,
}) async {
  return myAlertDialogue(
    context: context,
    alertTitle: "Confirmation to Save Product?",
    alertContent:
        "You are about to save this product, only proceed if you have fill out all the details in the form.",
    onApprovalPressed: () async {
      showMyAnimatedSnackBar(
        context: context,
        widgetToDisplay: MyProgressIndicator(),
        dataToDisplay: "Saving changes",
      );

      final currentlyLoggedInUser = ref
          .read(currentLoggedInUserControllerProvider)
          .valueOrNull;
      if (currentlyLoggedInUser == null) {
        showMyAnimatedSnackBar(
          context: context,
          dataToDisplay:
              "Could not retrieve user info. Please check your connection.",
        );
        return;
      }

      final storeID = currentlyLoggedInUser.currentStoreInView;
      final productRepoRef = ref.read(productRepositoryProvider(storeID));

      // ref
      //     .read(allListedProductsProvider.notifier)
      //     .removeProductFromTheList(product);

      // Update the product on the database
      await productRepoRef.update(product.id!, product);

      // // Update the newly added product to the cached list
      // ref
      //     .read(allListedProductsProvider.notifier)
      //     .addNewProductToTheList(product);

      Navigator.pop(context);
      Navigator.pop(context);
    },
  );
}
