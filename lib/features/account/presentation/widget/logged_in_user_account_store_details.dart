import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/dropdown.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/store/data/model/store_info.dart';
import 'package:pos_system/features/store/presentation/state_management/user_stores_controller.dart';
import 'package:pos_system/features/store/presentation/widgets/mini_widgets/no_store_yet.dart';
import 'package:pos_system/features/store/presentation/widgets/register_store_form.dart';

class LoggedInUserAccountStoreDetails extends ConsumerWidget {
  const LoggedInUserAccountStoreDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MyDimensions.getWidth(context);
    double height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;

    // Watch BOTH states
    final userState = ref.watch(currentLoggedInUserControllerProvider);
    final storesState = ref.watch(userStoresProvider);

    // SAFELY handle the loading states (No exclamation marks needed!)
    if (userState.isLoading || storesState.isLoading) {
      return const Center(child: MyProgressIndicator());
    }

    final personalInfo = userState.value;
    if (personalInfo == null) return const SizedBox(); // User not logged in

    final List<StoreInfo> storesList = storesState.value ?? [];

    // Create a list of Store NAMES for the dropdown
    List<String> storeNames = storesList
        .map((store) => store.storeName)
        .toList();
    if (storeNames.isEmpty) {
      return NoStoreYet();
    }
    ;
    storeNames.add("Register New Store?");

    // Find the NAME of the currently active store to show in the dropdown
    String? currentStoreName;
    try {
      currentStoreName = storesList
          .firstWhere((store) => store.id == personalInfo.currentStoreInView)
          .storeName;
    } catch (e) {
      currentStoreName = null;
    }

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: MyDropdownMenuButton(
            items: storeNames,
            initialValue: currentStoreName ?? "None", // Show the NAME
            isLeadingIconVisible: false,
            onChanged: (selectedName) {
              if (selectedName == null) return;
              // Prevents calling database when already in the selected store
              if (selectedName == currentStoreName) return;

              if (selectedName == "Register New Store?") {
                showMyBottomSheet(
                  context: context,
                  child: const RegisterStoreForm(),
                );
              } else {
                // Find the ID that matches the Name they clicked
                final selectedStoreId = storesList
                    .firstWhere(
                      (storeInfo) => storeInfo.storeName == selectedName,
                    )
                    .id;

                // Send the ID to the Controller. ZERO database logic in the UI!
                ref
                    .read(currentLoggedInUserControllerProvider.notifier)
                    .changeCurrentStore(selectedStoreId!);
              }
            },
            widthPercentage: 0.7,
            heightPercentage: 0.02,
          ),
        ),

        MyContainer(
          width: width * 0.675,
          height: height * 0.056,
          customBorderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          borderColor: myColorScheme.secondaryContainer.withAlpha(180),
          child: MyText(
            text: storeRoleIdentifyer(
              personalInfo: personalInfo,
              storeID: personalInfo.currentStoreInView,
            ).toUpperCase(),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: myColorScheme.primaryFixed,
          ),
        ),
        SizedBox(height: 16),

        MyText(text: "Selected Store: ${currentStoreName ?? "None"}"),
      ],
    );
  }

  String storeRoleIdentifyer({
    required PersonalInfo personalInfo,
    required String storeID,
  }) {
    if (personalInfo.ownerAt.contains(storeID)) {
      return "Owner";
    } else if (personalInfo.staffAt.contains(storeID)) {
      return "Staff";
    } else if (personalInfo.customerAt.contains(storeID)) {
      return "Customer";
    } else {
      return "Please select a store";
    }
  }
}
