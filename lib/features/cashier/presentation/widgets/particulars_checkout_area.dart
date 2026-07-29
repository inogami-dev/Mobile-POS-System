import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/cashier/presentation/state_management/to_checkout.dart';
import 'package:pos_system/features/cashier/presentation/widgets/particulars_area_mini_widgets.dart/layout/bottom_button_row.dart';
import 'package:pos_system/features/cashier/presentation/widgets/particulars_area_mini_widgets.dart/layout/textfields_area.dart';

class ParticularsCheckoutArea extends ConsumerStatefulWidget {
  final List<ScannedItem> scannedItems;
  ParticularsCheckoutArea({super.key, required this.scannedItems});

  @override
  ConsumerState<ParticularsCheckoutArea> createState() =>
      _ParticularsCheckoutAreaState();
}

class _ParticularsCheckoutAreaState
    extends ConsumerState<ParticularsCheckoutArea> {
  late ColorScheme myColorScheme;
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController changeController = TextEditingController();

  void paymentControllerListener() {
    if (paymentController.text.isNotEmpty) {
      setState(() {
        changeController.text =
            (double.parse(paymentController.text) -
                    double.parse(totalAmountController.text))
                .toString();
      });
    } else {
      setState(() => changeController.text = "");
    }
  }

  Color? changeColorChanger({required Color normal, required Color error}) {
    if (changeController.text.isEmpty) return null;

    if (double.parse(changeController.text) < 0) {
      return error;
    } else {
      return normal;
    }
  }

  @override
  void initState() {
    super.initState();
    paymentController.addListener(paymentControllerListener);
  }

  @override
  void dispose() {
    super.dispose();
    totalAmountController.dispose();
    paymentController.dispose();
    changeController.dispose();
    changeController.removeListener(paymentControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    final width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);
    myColorScheme = Theme.of(context).colorScheme;
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
          LayoutTextfieldsArea(
            animationDuration: animationDuration,
            toCheckout: toCheckout,
            myColorScheme: myColorScheme,
            width: width,
            height: height,
            totalAmountController: totalAmountController,
            paymentController: paymentController,
            changeController: changeController,
            changeTextColor: changeColorChanger(
              normal: myColorScheme.onSurface,
              error: myColorScheme.error,
            ),
          ),

          LayoutBottomButtonRow(
            scannedItems: widget.scannedItems,
            height: height,
            width: width,
            myColorScheme: myColorScheme,
            paymentController: paymentController,
            changeController: changeController,
            onControllerValueReset: (value) {
              setState(() {
                paymentController.text = value;
                changeController.text = value;
              });
            },
          ),
          SizedBox(height: MyAppLayout.bottomNavbarHeight + 15),
        ],
      ),
    );
  }
}
