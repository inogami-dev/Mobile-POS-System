import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/features/account/presentation/widget/logged_in_account_details.dart';

class LoggedInUserAccount extends ConsumerStatefulWidget {
  final AsyncValue<List<PersonalInfo>> userState;
  const LoggedInUserAccount({super.key, required this.userState});

  @override
  ConsumerState<LoggedInUserAccount> createState() =>
      _LoggedInUserAccountState();
}

class _LoggedInUserAccountState extends ConsumerState<LoggedInUserAccount> {
  late double width;
  late double height;
  String? _profileImage;
  List<PersonalInfo>? allUsers = [];
  PersonalInfo? loggedInUserInfo;

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;

    allUsers = widget.userState.value;

    if (allUsers != null) {
      loggedInUserInfo = allUsers!.firstWhere((user) {
        if (_profileImage == null) setState(() => _profileImage = user.picture);
        return user.id == user.id;
      });
    }

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
          ),
          SizedBox(height: 8),

          (loggedInUserInfo != null)
              ? GestureDetector(
                  onTap: () {},
                  child: LoggedInUserAccountDetails(
                    personalInfo: loggedInUserInfo!,
                  ),
                )
              : MyText(text: "No User", fontSize: kDefaultFontSize + 10),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
