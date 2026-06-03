import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';

class LoggedInUserAccountStoreDetails extends StatelessWidget {
  final PersonalInfo personalInfo; // to be implemented later
  const LoggedInUserAccountStoreDetails({
    super.key,
    required this.personalInfo,
  });

  @override
  Widget build(BuildContext context) {
    double width = MyDimensions.getWidth(context);
    // double height = MyDimensions.getHeight(context);
    List<String> storeNames = ["Store 1", "Store 2", "Store 3"];

    final myColorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: MyDropdownMenuButton(
            items: storeNames,
            initialValue: storeNames[0],
            isLeadingIconVisible: false,
            onChanged: (string) {},
            widthPercentage: 0.7,
            heightPercentage: 0.02,
          ),
        ),

        MyContainer(
          width: width * 0.675,
          customBorderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          borderColor: myColorScheme.onSecondaryFixed.withAlpha(200),
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
