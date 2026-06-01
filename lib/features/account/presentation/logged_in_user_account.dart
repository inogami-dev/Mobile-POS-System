import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_controller.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';

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

  List<String> storeRoles = ["Owner", "Staff", "Customer"];
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

    // userState.when(
    //   data: (data) {},
    //   error: (error, stackTrace) {},
    //   loading: () {},
    // );

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: myColorScheme.surfaceBright),
            borderRadius: BorderRadius.circular(100),
          ),
          child: GestureDetector(
            onTap: () async {
              String pickedImageBase64 = await MyImageProcessor.myImagePicker();
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

        GestureDetector(
          onTap: () {},
          child: FittedBox(
            child: MyText(
              text: loggedInUserInfo?.name ?? "No Name",
              fontSize: 36,
              fontWeight: FontWeight.w700,
            ),
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
          width: width * 0.68,
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
      ],
    );
  }
}
