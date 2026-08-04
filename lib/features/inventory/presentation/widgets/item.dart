import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/hero.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/navigator.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item_contents.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item_hero.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/state_management/product_repo_ref_controller.dart';

class MyItem extends ConsumerWidget {
  final ProductModel product;
  final Uint8List? productImage;
  const MyItem({super.key, required this.product, required this.productImage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double displayWidth = MediaQuery.of(context).size.width * 0.45;
    double displayHeight = MediaQuery.of(context).size.height * 0.08;
    final myColorScheme = Theme.of(context).colorScheme;
    // final productImage = MyImageProcessor.decodeStringToUint8List(
    //   product.picture,
    // );

    return GestureDetector(
      onTap: () {
        MyNavigator.goTo(
          context,
          ItemHero(heroTag: product.id!, product: product),
          animationType: MyAnimationType.fade,
        );
      },
      child: (product.id != null)
          ? MyHero(
              tag: product.id!,
              child: GestureDetector(
                onLongPress: () {
                  myAlertDialogue(
                    context: context,
                    alertTitle: "Delete Product",
                    alertContent:
                        "Are you sure you want to delete this product? It can't be undone.",
                    onApprovalButtonText: "Delete Product",
                    onCancelButtonText: "Abort",
                    onApprovalButtonTextColor: myColorScheme.error.withAlpha(
                      200,
                    ),
                    onApprovalPressed: () async {
                      await onConfirmation(context, ref);
                      Navigator.pop(context);
                    },
                  );
                },
                child: MyItemContents(
                  width: displayWidth,
                  height: displayHeight,
                  product: product,
                  isExpanded: false,
                  encodedProductImage: productImage!,
                ),
              ),
            )
          : MyProgressIndicator(),
    );
  }

  /// This function is for deleting a product in both local and remote storage.
  Future<void> onConfirmation(BuildContext context, WidgetRef ref) async {
    showMyAnimatedSnackBar(
      context: context,
      widgetToDisplay: MyProgressIndicator(),
      dataToDisplay: "Deleting..",
    );
    // Current Store in View's ID
    final storeID = ref
        .read(currentLoggedInUserControllerProvider)
        .value!
        .currentStoreInView;
    // Delete the product in the store that's currently in view
    await ref.read(productRepositoryProvider(storeID)).delete(product.id!);
    ref
        .read(allListedProductsProvider.notifier)
        .removeProductFromTheList(product);
    log("Product ID await: ${product.id}");

    showMyAnimatedSnackBar(
      context: context,
      dismissTimeInMillis: 1000,
      widgetToDisplay: HugeIcon(icon: HugeIcons.strokeRoundedCheckmarkBadge01),
      dataToDisplay: "Successfully Deleted!",
    );
  }
}
