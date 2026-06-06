import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_repo_provider.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';
import 'package:pos_system/features/store/presentation/state_management/store_info_controller.dart';
import 'package:pos_system/features/store/presentation/widgets/register_store_form.dart';

class LoggedInUserAccountStoreDetails extends ConsumerStatefulWidget {
  final PersonalInfo personalInfo; // to be implemented later
  const LoggedInUserAccountStoreDetails({
    super.key,
    required this.personalInfo,
  });

  @override
  ConsumerState<LoggedInUserAccountStoreDetails> createState() =>
      _LoggedInUserAccountStoreDetailsState();
}

class _LoggedInUserAccountStoreDetailsState
    extends ConsumerState<LoggedInUserAccountStoreDetails> {
  String? selectedStore;

  @override
  Widget build(BuildContext context) {
    double width = MyDimensions.getWidth(context);
    StoreInfo store = ref.watch(storeInfoRepoControllerProvider);

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
            initialValue: widget.personalInfo.currentStoreInView,
            // isTextWithImage: true,
            isLeadingIconVisible: false,
            onChanged: (value) {
              setState(() => selectedStore = value);

              if (selectedStore == storeNames.last) {
                // setState(() => selectedStore = storeNames[0]);
                showMyBottomSheet(context: context, child: RegisterStoreForm());
              } else {
                ref
                    .read(storeInfoRepoControllerProvider.notifier)
                    .setCurrentStore(value!);
                // Update the currentStoreInView field in the PersonalInfo, so that next time the app open this specific store first
                ref
                    .read(myPersonalInfoRepoProvider)
                    .update(
                      widget.personalInfo.id!,
                      widget.personalInfo.copyWith(currentStoreInView: value),
                    );
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
            text: storeRoleIdentifyer(selectedStore ?? "None").toUpperCase(),
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

  String storeRoleIdentifyer(String storeID) {
    if (widget.personalInfo.ownerAt.contains(storeID)) {
      return "Owner";
    } else if (widget.personalInfo.staffAt.contains(storeID)) {
      return "Staff";
    } else if (widget.personalInfo.customerAt.contains(storeID)) {
      return "Customer";
    } else {
      return "Please select a store";
    }
  }
}
