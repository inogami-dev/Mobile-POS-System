import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pos_system/core/constants/app_layout.dart';
import 'package:pos_system/core/models/personal_info/personal_info.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/appbar.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/domain/user_account_retriever.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<String> storeRoles = ["Owner", "Staff", "Customer"];
  bool isLoggingOut = false;
  String? _profileImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MyDimensions.getWidth(context);
    double height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: myColorScheme.surface,
      body: SingleChildScrollView(
        child: Container(
          width: MyDimensions.getWidth(context),
          height: MyDimensions.getHeight(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyAppBar(
                title: "Profile",
                enableBackButton: true,
                // actionsButtons: [
                //   Container(width: 50, height: 50, color: Colors.amber),
                //   Container(width: 50, height: 50, color: Colors.purple),
                // ],
              ),
              SizedBox(height: 32),

              GestureDetector(
                onTap: () async {
                  String pickedImageBase64 =
                      await MyImageProcessor.myImagePicker();
                  setState(() => _profileImage = pickedImageBase64);
                },
                child: MyImageDisplayer(
                  profileImageSize: width * 0.3,
                  base64ImageString: MyImageProcessor.decodeStringToUint8List(
                    _profileImage ?? "",
                  ),
                ),
              ),
              SizedBox(height: 24),

              // MyContainer(
              //   width: 100,
              //   height: 80,
              //   child: const MyText(text: "Account"),
              // ),
              // SizedBox(height: 16),
              FittedBox(
                child: MyText(
                  text: "Lian Dyelo",
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 12),

              SizedBox(
                height: 50,
                child: MyDropdownMenuButton(
                  items: storeRoles,
                  initialValue: storeRoles[0],
                  isLeadingIconVisible: false,
                  onChanged: (string) {},
                  widthPercentage: 0.7,
                  heightPercentage: 0.02,
                ),
              ),

              MyContainer(
                width: MyDimensions.getWidth(context) * 0.68,
                customBorderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: MyText(
                  text: "Owner".toUpperCase(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: myColorScheme.primaryFixed,
                ),
              ),
              SizedBox(height: 16),

              Spacer(),
              (isLoggingOut)
                  ? const MyProgressIndicator()
                  : MyCustButton(
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
                    ),
              SizedBox(height: MyAppLayout.bottomNavbarHeight + 16),
            ],
          ),
        ),
      ),
    );
  }
}
