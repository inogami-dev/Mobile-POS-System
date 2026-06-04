import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/store/presentation/widgets/register_store_form.dart';

class LoggedInUserAccountStoreDetails extends StatefulWidget {
  final PersonalInfo personalInfo; // to be implemented later
  const LoggedInUserAccountStoreDetails({
    super.key,
    required this.personalInfo,
  });

  @override
  State<LoggedInUserAccountStoreDetails> createState() =>
      _LoggedInUserAccountStoreDetailsState();
}

class _LoggedInUserAccountStoreDetailsState
    extends State<LoggedInUserAccountStoreDetails> {
  String? selectedStore;

  @override
  Widget build(BuildContext context) {
    double width = MyDimensions.getWidth(context);

    List<String> storeNames = widget.personalInfo.ownerAt
        .map((store) => store)
        .toList();
    storeNames.addAll(widget.personalInfo.staffAt);
    storeNames.add("Register New Store?");

    final myColorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: MyDropdownMenuButton(
            items: storeNames,
            initialValue: storeNames[0],
            // isTextWithImage: true,
            isLeadingIconVisible: false,
            onChanged: (value) {
              setState(() => selectedStore = value);
              if (selectedStore == storeNames.last) {
                // setState(() => selectedStore = storeNames[0]);
                showMyBottomSheet(context: context, child: RegisterStoreForm());
              }
            },
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
          borderColor: myColorScheme.onSecondaryFixed,
          child: MyText(
            text: "Owner".toUpperCase(),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: myColorScheme.primaryFixed,
          ),
        ),
        SizedBox(height: 16),

        MyText(text: "Selected Store: ${selectedStore ?? "None"}"),
      ],
    );
  }
}
