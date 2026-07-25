import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';
import 'package:pos_system/features/cashier/presentation/widgets/particulars_area_mini_widgets.dart/input_quantity.dart';

class MyParticularsPopup {
  MyParticularsPopup._();

  static VoidCallback toEdit(
    BuildContext context, {
    required WidgetRef ref,
    required String productBarcode,
    required int initQuantity,
  }) {
    return () {
      try {
        int currentQuantity = initQuantity;

        myAlertDialogue(
          context: context,
          onApprovalPressed: () {
            ref
                .read(toCounterItemsProvider.notifier)
                .editAProductQuantity(
                  barcode: productBarcode,
                  quantity: currentQuantity.toDouble(),
                );
            Navigator.pop(context);
          },
          alertTitle: "Edit Quantity",
          alertContent: "(Press the arrows to change.)",
          onApprovalButtonText: "Save Quantity",
          onCancelButtonText: "Cancel Changes",
          contentWidget: MyInputQuantity(
            quantity: initQuantity,
            onQuantityChanged: (newQuantity) {
              currentQuantity = newQuantity;
            },
          ),
        );
      } catch (e, stackTrace) {
        log(
          "There is an error occured on toEdit in MyParticularsPopup.dart \nThe Error is $e at $stackTrace",
        );
      }
    };
  }

  static VoidCallback toDelete(
    BuildContext context, {
    required WidgetRef ref,
    required String productBarcode,
  }) {
    return () {
      int dismissTimeInMillis = 700;
      try {
        myAlertDialogue(
          context: context,
          alertTitle: "Remove Item",
          alertContent:
              "Are you sure you want to remove this item from the list? It cannot be undone.",
          onApprovalPressed: () async {
            ref
                .read(toCounterItemsProvider.notifier)
                .removeAProductFromCounter(productBarcode);
            showMyAnimatedSnackBar(
              context: context,
              widgetToDisplay: MyProgressIndicator(),
              dismissTimeInMillis: dismissTimeInMillis,
              dataToDisplay: "Removing the item from the list...",
            );
            Future.delayed(Duration(milliseconds: dismissTimeInMillis), () {
              Navigator.pop(context);
            });
          },
        );
      } catch (e, stackTrace) {
        log(
          "There is an error occured on toDelete in MyParticularsPopup.dart \nThe Error is $e at $stackTrace",
        );
      }
    };
  }
}
