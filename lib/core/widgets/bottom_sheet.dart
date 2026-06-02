import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';

showMyBottomSheet({required BuildContext context, required Widget child}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        width: MyDimensions.getWidth(context),
        height: MyDimensions.getHeight(context) * 0.835,
        decoration: BoxDecoration(
          // color: Colors.purple[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: child,
      );
    },
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}
