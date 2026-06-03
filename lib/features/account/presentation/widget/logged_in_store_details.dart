import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class LoggedInStoreDetails extends StatelessWidget {
  const LoggedInStoreDetails({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MyDimensions.getWidth(context);
    double height = MyDimensions.getHeight(context);
    List<String> storeRoles = ["Owner", "Staff", "Customer"];

    final myColorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
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
