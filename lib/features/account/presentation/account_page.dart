import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: myColorScheme.surface,
      body: Container(
        width: MyDimensions.getWidth(context),
        height: MyDimensions.getHeight(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyContainer(
              width: 100,
              height: 80,
              child: const MyText(text: "Account"),
            ),
            SizedBox(height: 20),
            (isLoggingOut)
                ? const MyProgressIndicator()
                : MyCustButton(
                    buttonText: "Logout",
                    onTap: () {
                      // myAlertDialogue(
                      //   context: context,
                      //   alertTitle: "Logout",
                      //   alertContent: "Are you sure you want to logout?",
                      //   onApprovalPressed: () {
                      //     setState(() => isLoggingOut = true);
                      //     FirebaseAuth.instance.signOut();
                      //     setState(() => isLoggingOut = false);
                      //     Navigator.pop(context);
                      //   },
                      // );

                      showMyAnimatedSnackBar(
                        context: context,
                        dataToDisplay: "Hello",
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
