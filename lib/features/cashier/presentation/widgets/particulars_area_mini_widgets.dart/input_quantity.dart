import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/text_field.dart';

class MyInputQuantity extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  const MyInputQuantity({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  State<MyInputQuantity> createState() => _MyInputQuantityState();
}

class _MyInputQuantityState extends State<MyInputQuantity> {
  TextEditingController textController = TextEditingController();
  int effectiveQuantity = 0;

  @override
  void initState() {
    super.initState();
    textController.text = widget.quantity.toString();
    effectiveQuantity = widget.quantity;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);

    final myColorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextfield(
              labelText: "",
              textController: textController,
              textInputType: TextInputType.number,
              widthPercentage: 0.32,
              heightPercentage: 0.085,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: myColorScheme.onSurface,
                fontFamily: "Quicksand",
              ),
              borderRadius: 8,
              isUsingStaticDimension: false,
            ),
            SizedBox(width: 8),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 2,
              children: [
                IconButton.outlined(
                  onPressed: () {
                    setState(() {
                      effectiveQuantity++;
                      textController.text = effectiveQuantity.toString();
                      widget.onQuantityChanged(effectiveQuantity);
                    });
                  },
                  visualDensity: VisualDensity.compact,
                  color: myColorScheme.outlineVariant,
                  padding: EdgeInsets.zero,
                  highlightColor: myColorScheme.primary.withAlpha(156),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      myColorScheme.outlineVariant,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  constraints: _arrowButtonsSize(width, height),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowUp01,
                    size: 32,
                    color: myColorScheme.primary,
                  ),
                ),
                IconButton.outlined(
                  onPressed: () {
                    // Prevent from going below 1
                    if (effectiveQuantity <= 1) {
                      showMyAnimatedSnackBar(
                        context: context,
                        dataToDisplay:
                            "The quantity of an item in the counter must be of at least 1.",
                      );
                      return;
                    }
                    setState(() {
                      effectiveQuantity--;
                      textController.text = effectiveQuantity.toString();
                      widget.onQuantityChanged(effectiveQuantity);
                    });
                  },
                  visualDensity: VisualDensity.compact,
                  color: myColorScheme.outlineVariant,
                  padding: EdgeInsets.zero,
                  highlightColor: myColorScheme.primary.withAlpha(156),
                  style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: WidgetStateProperty.all(
                      myColorScheme.outlineVariant,
                    ),
                  ),
                  constraints: _arrowButtonsSize(width, height),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    size: 32,
                    color: myColorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxConstraints _arrowButtonsSize(double width, double height) {
    return BoxConstraints.tight(Size(width * 0.15, height * 0.04));
  }
}
