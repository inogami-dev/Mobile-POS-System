import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/line.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_checkout.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_counter_items.dart';
import 'package:pos_system/features/cashier/presentation/widgets/counter_scanner.dart';
import 'package:pos_system/features/cashier/presentation/widgets/particulars_area.dart';

class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({super.key});

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage> {
  late double width;
  late double height;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;
    List<ScannedItem> scannedItems = ref.watch(toCounterItemsProvider);
    int currentIndex = ref.watch(rootScaffoldStateProvider);
    final toCheckout = ref.watch(toCheckoutProvider);

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  // if (currentIndex == 1 && !toCheckout)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: (currentIndex == 1 && !toCheckout)
                        ? height * 0.4
                        : 0,
                    curve: Curves.easeInOutCubic,
                    child: AnimatedOpacity(
                      opacity: (toCheckout) ? 0 : 1,
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.easeInOutCubic,
                      child: SafeArea(
                        bottom: false,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(8),
                          child: MyCounterScanner(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Row(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyLine(
                          length: width / 3,
                          isVertical: false,
                          color: myColorScheme.outline.withAlpha(80),
                        ),
                        MyText(
                          text: "Particulars",
                          fontSize: kDefaultFontSize - 4,
                        ),
                        MyLine(
                          length: width / 3,
                          isVertical: false,
                          color: myColorScheme.outline.withAlpha(80),
                        ),
                      ],
                    ),
                  ),
                  ParticularsArea(
                    scrollController: scrollController,
                    height: height,
                    scannedItems: scannedItems,
                    myColorScheme: myColorScheme,
                    width: width,
                  ),
                ],
              ),
            ),

            // Clear Button
            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              bottom: (toCheckout) ? height * 0.13 : -10,
              left: 24,
              child: MyButton(
                // widthPercentage: 0.1,
                buttonText: "Clear",
                isUsedAsAbortButton: true,
                color: myColorScheme.primary.withAlpha(56),
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
                      // Revert back the scanner (reopen the scanner)
                      ref.read(toCheckoutProvider.notifier).toggle(false);
                      // Show a cue that the transaction is successful aborted
                      showMyAnimatedSnackBar(
                        context: context,
                        icon: Icon(Icons.check_rounded, color: Colors.green),
                        dataToDisplay: "Aborted the Transaction!",
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),

            AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              bottom: (toCheckout) ? height * 0.13 : -10,
              right: 24,
              child: MyButton(
                buttonText: "Checkout",
                // color: myColorScheme.primary.withAlpha(56),
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

                  myAlertDialogue(
                    context: context,
                    alertTitle: "Confirm Checkout",
                    alertContent:
                        "Please confirm that the items in the list are correct as this action cannot be undone.",
                    onApprovalPressed: () async {
                      await ref
                          .read(toCounterItemsProvider.notifier)
                          .checkoutCompletion(scannedItems);
                      // Show a cue that the transaction is successful
                      showMyAnimatedSnackBar(
                        context: context,
                        icon: Icon(Icons.check_rounded, color: Colors.green),
                        dataToDisplay: "Successful Transaction!",
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
