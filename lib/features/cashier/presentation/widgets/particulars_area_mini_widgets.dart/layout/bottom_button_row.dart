import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_checkout.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';
import 'package:pos_system/features/sales/presentation/state_management/sales_controller.dart';

class LayoutBottomButtonRow extends ConsumerWidget {
  final List<ScannedItem> scannedItems;
  final height;
  final width;
  final ColorScheme myColorScheme;
  final paymentController;
  final changeController;
  final ValueChanged<String> onControllerValueReset;

  const LayoutBottomButtonRow({
    super.key,
    required this.scannedItems,
    required this.height,
    required this.width,
    required this.myColorScheme,
    required this.paymentController,
    required this.changeController,
    required this.onControllerValueReset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned.fill(
      top: height * 0.25,
      child: Container(
        width: width,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: myColorScheme.surfaceContainerHigh,
          border: Border(
            top: BorderSide(color: myColorScheme.outline.withAlpha(156)),
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(50),
            topRight: const Radius.circular(50),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Clear Button
            MyButton(
              // widthPercentage: 0.1,
              buttonText: "Clear",
              isUsedAsAbortButton: true,
              color: Colors.transparent,
              onTap: () {
                if (scannedItems.isEmpty) {
                  showMyAnimatedSnackBar(
                    context: context,
                    icon: Icon(
                      Icons.error_outline_rounded,
                      color: myColorScheme.error,
                    ),
                    dataToDisplay: "Nothing to clear in here.",
                  );
                  // Revert back the scanner (reopen the scanner)
                  ref.read(toCheckoutProvider.notifier).toggle(false);
                  return;
                }

                myAlertDialogue(
                  context: context,
                  alertTitle: "Clear the counter",
                  alertContent:
                      "Are you sure you want to cancel this transaction? This action cannot be undone.",
                  onApprovalPressed: () {
                    // Clear the counter
                    ref
                        .read(toCounterItemsProvider.notifier)
                        .abortTransaction();
                    onControllerValueReset("");
                    // Revert back the scanner (reopen the scanner)
                    ref.read(toCheckoutProvider.notifier).toggle(false);
                    // Show a cue that the transaction is successful aborted
                    showMyAnimatedSnackBar(
                      context: context,
                      icon: Icon(Icons.check_rounded, color: Colors.green),
                      dataToDisplay: "Aborted the Transaction!",
                    );
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pop(context);
                  },
                );
              },
            ),
            // Checkout Button
            MyButton(
              buttonText: "Checkout",
              onTap: () {
                if (scannedItems.isEmpty) {
                  showMyAnimatedSnackBar(
                    context: context,
                    icon: Icon(
                      Icons.error_outline_rounded,
                      color: myColorScheme.error,
                    ),
                    dataToDisplay: "Nothing to checkout in here.",
                  );
                  // Revert back the scanner (reopen the scanner)
                  ref.read(toCheckoutProvider.notifier).toggle(false);
                  return;
                }

                if (paymentController.text.isEmpty) {
                  showMyAnimatedSnackBar(
                    context: context,
                    icon: Icon(
                      Icons.error_outline_rounded,
                      color: myColorScheme.error,
                    ),
                    dataToDisplay: "Input the payment amount first.",
                  );
                  return;
                }

                if (changeController.text.isNotEmpty &&
                    double.parse(changeController.text) < 0) {
                  showMyAnimatedSnackBar(
                    context: context,
                    icon: Icon(
                      Icons.error_outline_rounded,
                      color: myColorScheme.error,
                    ),
                    dataToDisplay:
                        "Invalid payment amount. Input the right amount.",
                  );
                  return;
                }

                myAlertDialogue(
                  context: context,
                  alertTitle: "Confirm Checkout",
                  alertContent:
                      "Please confirm that the items in the list are correct as this action cannot be undone.",
                  onApprovalPressed: () async {
                    await ref
                        .read(toCounterItemsProvider.notifier)
                        .checkoutCompletion(scannedItems);

                    await ref
                        .read(salesControllerProvider.notifier)
                        .saveToFirebase(
                          items: scannedItems,
                          payment: double.parse(paymentController.text),
                          change: double.parse(changeController.text),
                        );

                    // Show a cue that the transaction is successful
                    showMyAnimatedSnackBar(
                      context: context,
                      icon: Icon(Icons.check_rounded, color: Colors.green),
                      dataToDisplay: "Successful Transaction!",
                    );

                    // Clear the counter
                    onControllerValueReset("");

                    Navigator.pop(context);

                    // Add a little delay sp that the FocusScope will work properly here.
                    Future.delayed(Duration(milliseconds: 200), () {
                      // Close the checkout area
                      ref.read(toCheckoutProvider.notifier).toggle(false);
                      ref.invalidate(salesControllerProvider);
                      FocusScope.of(context).unfocus();
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
