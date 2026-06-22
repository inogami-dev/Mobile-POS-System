import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/account/presentation/widget/edit_profile_pricture_modal.dart';
import 'package:pos_system/features/account/presentation/widget/logged_in_user_account_details.dart';

class LoggedInUserAccount extends ConsumerStatefulWidget {
  const LoggedInUserAccount({super.key});

  @override
  ConsumerState<LoggedInUserAccount> createState() =>
      _LoggedInUserAccountState();
}

class _LoggedInUserAccountState extends ConsumerState<LoggedInUserAccount> {
  late double width;
  late double height;
  late PersonalInfo loggedInUserInfo;
  late ColorScheme myColorScheme;

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    myColorScheme = Theme.of(context).colorScheme;
    loggedInUserInfo = ref.watch(currentLoggedInUserControllerProvider).value!;

    return Container(
      width: width * 0.9,
      // color: Colors.green,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: myColorScheme.surfaceBright,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
            child: GestureDetector(
              onTap: () async {
                editProfilePicture(
                  context: context,
                  ref: ref,
                  myColorScheme: myColorScheme,
                  loggedInUserInfo: loggedInUserInfo,
                  width: width,
                );
              },
              child: MyImageDisplayer(
                profileImageSize: width * 0.3,
                base64ImageString: MyImageProcessor.decodeStringToUint8List(
                  loggedInUserInfo.picture,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),

          GestureDetector(
            onTap: () {},
            child: LoggedInUserAccountDetails(personalInfo: loggedInUserInfo),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
