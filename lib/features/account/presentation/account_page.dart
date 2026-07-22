import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/appbar.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_state.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/presentation/logged_in_user_account.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/account/presentation/widget/logged_in_user_account_store_details.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  late double width;
  late double height;
  bool isLoggingOut = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;

    var userState = ref.watch(currentLoggedInUserControllerProvider);

    return Scaffold(
      backgroundColor: myColorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Container(
            width: width,
            height: height * 1.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // MyAppBar(title: "Profile", enableBackButton: true),
                SizedBox(height: 32),

                if (userState.hasError)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MyText(
                        text: "Error loading profile details. Please check your internet connection.",
                        color: myColorScheme.error,
                      ),
                    ),
                  )
                else if (userState.isLoading || userState.valueOrNull == null)
                  Center(child: MyProgressIndicator())
                else
                  Expanded(
                    child: Column(
                      children: [
                        LoggedInUserAccount(),
                        LoggedInUserAccountStoreDetails(),

                        Spacer(),
                        (isLoggingOut)
                            ? const MyProgressIndicator()
                            : loggoutButton(context),
                        SizedBox(
                          height: MyAppLayout.bottomNavbarHeight + 16,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // MyButton loggoutButton(BuildContext context) {
  //   return MyButton(
  //     buttonText: "Logout",
  //     onTap: () {
  //       myAlertDialogue(
  //         context: context,
  //         alertTitle: "Logout",
  //         alertContent: "Are you sure you want to logout?",
  //         onApprovalPressed: () {
  //           setState(() => isLoggingOut = true);
  //           FirebaseAuth.instance.signOut();
  //           setState(() => isLoggingOut = false);
  //           Navigator.pop(context);
  //
  //           ref
  //               .read(currentLoggedInUserControllerProvider.notifier)
  //               .setCurrentLoggedInUser(null);
  //
  //           ref.read(rootScaffoldStateProvider.notifier).changeIndex(0);
  //         },
  //       );
  //
  //       // showMyAnimatedSnackBar(
  //       //   context: context,
  //       //   dataToDisplay: "Hello",
  //       // );
  //     },
  //   );
  // }

  MyButton loggoutButton(BuildContext context) {
    return MyButton(
      buttonText: "Logout",
      onTap: () {
        myAlertDialogue(
          context: context,
          alertTitle: "Log Out",
          alertContent: "Are you sure you want to log out?",
          onApprovalPressed: () {
            // ALL YOU NEED TO DO IS THIS:
            FirebaseAuth.instance.signOut();

            // Pop the dialog
            Navigator.pop(context);

            // Optional: reset your nav bar index if needed
            ref.read(rootScaffoldStateProvider.notifier).changeIndex(0);

            // You DO NOT need to manually set the user to null anymore!
            // When signOut() is called, firebaseAuthStreamProvider detects it,
            // tells CurrentLoggedInUserController, which returns null,
            // which instantly updates LoggedInStream to show the LoginPage!
          },
        );
      },
    );
  }
}
