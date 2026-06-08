import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_repo_provider.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';
import 'package:pos_system/features/store/presentation/state_management/store_info_controller.dart';
import 'package:pos_system/features/store/presentation/widgets/register_store_form.dart';

class LoggedInUserAccountStoreDetails extends ConsumerStatefulWidget {
  const LoggedInUserAccountStoreDetails({super.key});

  @override
  ConsumerState<LoggedInUserAccountStoreDetails> createState() =>
      _LoggedInUserAccountStoreDetailsState();
}

class _LoggedInUserAccountStoreDetailsState
    extends ConsumerState<LoggedInUserAccountStoreDetails> {
  // String? selectedStore;
  late PersonalInfo? personalInfo;

  @override
  Widget build(BuildContext context) {
    double width = MyDimensions.getWidth(context);
    final currentlyLoggedInUserData = ref.watch(
      currentLoggedInUserControllerProvider,
    );
    // This
    StoreInfo store = ref.watch(storeInfoRepoControllerProvider);

    personalInfo = currentlyLoggedInUserData.value;
    late List<String> storeNames;
    storeNames = personalInfo!.ownerAt.map((store) => store).toList();
    storeNames.addAll(personalInfo!.staffAt);
    storeNames.add("Register New Store?");

    final myColorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: MyDropdownMenuButton(
            items: storeNames,
            initialValue: personalInfo!.currentStoreInView,
            isLeadingIconVisible: false,
            onChanged: (value) {
              if (value == storeNames.last) {
                showMyBottomSheet(context: context, child: RegisterStoreForm());
              } else {
                ref
                    .read(storeInfoRepoControllerProvider.notifier)
                    .setCurrentStore(value!);
                // Update the currentStoreInView field in the PersonalInfo, so that next time the app open this specific store first
                ref
                    .read(myPersonalInfoRepoProvider)
                    .update(
                      personalInfo!.id!,
                      personalInfo!.copyWith(currentStoreInView: value),
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
            text: storeRoleIdentifyer(
              personalInfo!.currentStoreInView,
            ).toUpperCase(),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: myColorScheme.primaryFixed,
          ),
        ),
        SizedBox(height: 16),

        MyText(text: "Selected Store: ${personalInfo!.currentStoreInView}"),
      ],
    );
  }

  String storeRoleIdentifyer(String storeID) {
    if (personalInfo!.ownerAt.contains(storeID)) {
      return "Owner";
    } else if (personalInfo!.staffAt.contains(storeID)) {
      return "Staff";
    } else if (personalInfo!.customerAt.contains(storeID)) {
      return "Customer";
    } else {
      return "Please select a store";
    }
  }
}
