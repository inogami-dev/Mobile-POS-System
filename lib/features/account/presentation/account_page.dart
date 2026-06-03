import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/appbar.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/features/account/presentation/logged_in_user_account.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_controller.dart';
import 'package:pos_system/features/account/presentation/widget/logged_in_store_details.dart';

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

    var userState = ref.watch(personalInfoControllerProvider);

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
                MyAppBar(title: "Profile", enableBackButton: true),
                SizedBox(height: 32),

                LoggedInUserAccount(userState: userState),
                LoggedInStoreDetails(),

                Spacer(),
                (isLoggingOut)
                    ? const MyProgressIndicator()
                    : loggoutButton(context),
                SizedBox(height: MyAppLayout.bottomNavbarHeight + 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MyCustButton loggoutButton(BuildContext context) {
    return MyCustButton(
      buttonText: "Logout",
      onTap: () {
        myAlertDialogue(
          context: context,
          alertTitle: "Logout",
          alertContent: "Are you sure you want to logout?",
          onApprovalPressed: () {
            setState(() => isLoggingOut = true);
            FirebaseAuth.instance.signOut();
            setState(() => isLoggingOut = false);
            Navigator.pop(context);
          },
        );

        // showMyAnimatedSnackBar(
        //   context: context,
        //   dataToDisplay: "Hello",
        // );
      },
    );
  }
}
