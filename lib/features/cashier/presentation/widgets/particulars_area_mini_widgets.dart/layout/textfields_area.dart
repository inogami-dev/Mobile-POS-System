import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/widgets/text_field.dart';

class LayoutTextfieldsArea extends StatelessWidget {
  final double width;
  final double height;
  static const animationCurve = Curves.easeInOutCubic;
  final Duration animationDuration;
  final bool toCheckout;
  final ColorScheme myColorScheme;
  final TextEditingController totalAmountController;
  final TextEditingController paymentController;
  final TextEditingController changeController;
  final Color? changeTextColor;

  const LayoutTextfieldsArea({
    super.key,
    required this.animationDuration,
    required this.toCheckout,
    required this.myColorScheme,
    required this.width,
    required this.height,
    required this.totalAmountController,
    required this.paymentController,
    required this.changeController,
    required this.changeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
              prefixIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedMoney01,
                color: myColorScheme.outline,
              ),
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
                  color: myColorScheme.onSurfaceVariant,
                ),
                prefixIconConstraints: Size(50, 24),
                activeBorderColor: myColorScheme.outline,
                style: TextStyle(
                  fontSize: kDefaultFontSize + 6,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Quicksand",
                  // color: changeColorChanger(
                  //   normal: myColorScheme.onSurface,
                  //   error: myColorScheme.error,
                  // ),
                  color: changeTextColor,
                ),
                isReadOnly: true,
                textController: changeController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
