import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_checkout.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';

class ParticularsCheckoutArea extends ConsumerStatefulWidget {
  final List<ScannedItem> scannedItems;
  ParticularsCheckoutArea({super.key, required this.scannedItems});

  @override
  ConsumerState<ParticularsCheckoutArea> createState() =>
      _ParticularsCheckoutAreaState();
}

class _ParticularsCheckoutAreaState
    extends ConsumerState<ParticularsCheckoutArea> {
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController changeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    totalAmountController.dispose();
    paymentController.dispose();
    changeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;
    final toCheckout = ref.watch(toCheckoutProvider);
    const animationDuration = Duration(milliseconds: 500);
    const animationCurve = Curves.easeInOutCubic;
    totalAmountController.text = widget.scannedItems.fold<double>(0, (
      total,
      currentVal,
    ) {
      return total + (currentVal.price * currentVal.quantity);
    }).toString();

    return AnimatedContainer(
      duration: animationDuration,
      width: width,
      height: height * 0.32,
      decoration: BoxDecoration(
        // color: myColorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      curve: animationCurve,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Textfields
          AnimatedContainer(
            duration: animationDuration,
            curve: animationCurve,
            width: (toCheckout) ? width * 0.9 : width,
            padding: EdgeInsets.fromLTRB(8, 16, 8, 24),
            decoration: BoxDecoration(
              color: myColorScheme.outlineVariant,
              borderRadius: BorderRadius.circular((toCheckout) ? 16 : 32),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: width * 0.8,
                  height: height * 0.056,
                  child: MyTextfield(
                    isUsingStaticDimension: false,
                    widthPercentage: width * 0.8,
                    heightPercentage: height * 0.006,
                    labelText: "Total Amount",
                    borderRadius: 8,
                    borderColor: myColorScheme.outlineVariant,
                    prefixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedPhilippinePeso,
                      size: 22,
                      color: myColorScheme.outline,
                    ),
                    prefixIconConstraints: Size(50, 24),
                    activeBorderColor: myColorScheme.outline,
                    style: TextStyle(
                      fontSize: kDefaultFontSize + 4,
                      fontFamily: "Quicksand",
                    ),
                    isReadOnly: true,
                    textController: totalAmountController,
                  ),
                ),
                // ),
                const SizedBox(height: 8),

                AnimatedOpacity(
                  opacity: (toCheckout) ? 1 : 0,
                  duration: animationDuration,
                  curve: animationCurve,
                  child: MyTextfield(
                    isReadOnly: (toCheckout) ? false : true,
                    prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMoney01),
                    labelText: "Payment Money",
                    textInputType: TextInputType.number,
                    textController: paymentController,
                    style: TextStyle(
                      fontSize: kDefaultFontSize + 4,
                      fontFamily: "Quicksand",
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                AnimatedOpacity(
                  opacity: (toCheckout) ? 1 : 0,
                  duration: animationDuration,
                  curve: animationCurve,
                  child: SizedBox(
                    width: width * 0.8,
                    height: height * 0.056,
                    child: MyTextfield(
                      isUsingStaticDimension: false,
                      widthPercentage: width * 0.8,
                      heightPercentage: height * 0.006,
                      labelText: "Change",
                      borderRadius: 8,
                      borderColor: myColorScheme.outlineVariant,
                      prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedPhilippinePeso,
                        size: 22,
                        color: myColorScheme.outline,
                      ),
                      prefixIconConstraints: Size(50, 24),
                      activeBorderColor: myColorScheme.outline,
                      style: TextStyle(
                        fontSize: kDefaultFontSize + 4,
                        fontFamily: "Quicksand",
                      ),
                      isReadOnly: true,
                      textController: changeController,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned.fill(
            top: height * 0.25,
            child: Container(
              width: width,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: myColorScheme.outline,
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
                      if (widget.scannedItems.isEmpty) {
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
                          // Revert back the scanner (reopen the scanner)
                          ref.read(toCheckoutProvider.notifier).toggle(false);
                          // Show a cue that the transaction is successful aborted
                          showMyAnimatedSnackBar(
                            context: context,
                            icon: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                            ),
                            dataToDisplay: "Aborted the Transaction!",
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  // Checkout Button
                  MyButton(
                    buttonText: "Checkout",
                    // color: myColorScheme.primary.withAlpha(56),
                    onTap: () {
                      if (widget.scannedItems.isEmpty) {
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

                      myAlertDialogue(
                        context: context,
                        alertTitle: "Confirm Checkout",
                        alertContent:
                            "Please confirm that the items in the list are correct as this action cannot be undone.",
                        onApprovalPressed: () async {
                          await ref
                              .read(toCounterItemsProvider.notifier)
                              .checkoutCompletion(widget.scannedItems);
                          // Show a cue that the transaction is successful
                          showMyAnimatedSnackBar(
                            context: context,
                            icon: Icon(
                              Icons.check_rounded,
                              color: Colors.green,
                            ),
                            dataToDisplay: "Successful Transaction!",
                          );
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: MyAppLayout.bottomNavbarHeight + 15),
        ],
      ),
    );
  }
}
