import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_info_expansible_ui_cotroller_.dart';

class LoggedInUserAccountDetails extends ConsumerStatefulWidget {
  final PersonalInfo personalInfo;
  const LoggedInUserAccountDetails({super.key, required this.personalInfo});

  @override
  ConsumerState<LoggedInUserAccountDetails> createState() =>
      _LoggedInUserAccountDetailsState();
}

class _LoggedInUserAccountDetailsState
    extends ConsumerState<LoggedInUserAccountDetails> {
  late ExpansibleController controller;

  @override
  Widget build(BuildContext context) {
    controller = ref.watch(expansibleControllerProvider);

    return Expansible(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      headerBuilder: (context, animation) => headerBuilder(context, animation),
      bodyBuilder: (context, animation) => bodyBuilder(context, animation),
      controller: controller,
    );
  }

  Widget headerBuilder(context, animation) {
    return GestureDetector(
      onTap: () {
        controller.isExpanded ? controller.collapse() : controller.expand();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          MyText(
            text: widget.personalInfo.name,
            textOverFlow: TextOverflow.ellipsis,
            fontSize: kDefaultFontSize + 15,
            fontWeight: FontWeight.w700,
          ),
          HugeIcon(
            icon: controller.isExpanded
                ? HugeIcons.strokeRoundedArrowUp01
                : HugeIcons.strokeRoundedArrowDown01,
          ),
        ],
      ),
    );
  }

  Widget bodyBuilder(context, animation) {
    return Container(
      height: MyDimensions.getHeight(context) * 0.27,
      // color: Colors.blueGrey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            bodyContentTile(
              text: widget.personalInfo.id ?? "Something went wrong..",
              icon: HugeIcon(icon: HugeIcons.strokeRoundedId),
            ),
            bodyContentTile(
              text: widget.personalInfo.email,
              icon: HugeIcon(icon: HugeIcons.strokeRoundedMail01),
            ),
            bodyContentTile(
              text: widget.personalInfo.contactNumber,
              icon: HugeIcon(icon: HugeIcons.strokeRoundedCall),
            ),
            bodyContentTile(
              text: widget.personalInfo.address,
              icon: HugeIcon(icon: HugeIcons.strokeRoundedLocation01),
            ),
            bodyContentTile(
              text: widget.personalInfo.sex,
              icon: HugeIcon(
                icon: (widget.personalInfo.sex.toUpperCase() == "MALE")
                    ? HugeIcons.strokeRoundedMale02
                    : HugeIcons.strokeRoundedFemale02,
              ),
            ),
            bodyContentTile(
              text: widget.personalInfo.age.toString(),
              icon: HugeIcon(icon: HugeIcons.strokeRoundedCalendar01),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyContentTile({required String text, required HugeIcon icon}) {
    return Container(
      // color: Colors.purple,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 24, right: 24),
        leading: icon,
        visualDensity: VisualDensity(vertical: -4),
        title: MyText(
          text: text,
          textOverFlow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}
