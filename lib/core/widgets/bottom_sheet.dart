import 'package:flutter/material.dart';

showMyBottomSheet({required BuildContext context, required Widget child}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // this removes the 50% limit
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        // this pushes the sheet upwards when the keyboard is opened
        padding: MediaQuery.of(context).viewInsets,
        // this is to prevent widget from overflowing
        child: SingleChildScrollView(
          child: Container(
            // width: MyDimensions.getWidth(context),
            // height: MyDimensions.getHeight(context) * 0.835,
            decoration: BoxDecoration(
              // color: Colors.purple[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: child,
          ),
        ),
      );
    },
  );
}
