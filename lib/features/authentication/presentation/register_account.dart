import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/features/authentication/presentation/register_account_form.dart';

/// context is for BuildContext, email and password will be used for RegisterAccountForm
void bottomModalSheetOfSignUp({
  required BuildContext context,
  required String email,
  required String password,
  required ColorScheme myColorScheme,
}) {
  showModalBottomSheet(
    backgroundColor: myColorScheme.surfaceContainer,
    context: context,
    builder: (context) {
      return Container(
        width: MyDimensions.getWidth(context),
        height: MyDimensions.getHeight(context) * 0.90,
        decoration: BoxDecoration(
          // color: Colors.purple[100],
          borderRadius: borderRadius(),
        ),
        child: RegisterAccountForm(
          email: email,
          password: password,
          borderRadius: borderRadius(),
        ),
      );
    },
    // this property removes the default limit of the modal bottom sheet (.50 of the screen height)
    isScrollControlled: true,
  );
}

BorderRadius borderRadius() {
  return const BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
  );
}
