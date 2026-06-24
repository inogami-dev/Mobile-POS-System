import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/data/repository/personal_info_repository.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_repo_provider.dart';
import 'package:pos_system/features/store/presentation/state_management/store_info_controller.dart';
import 'package:pos_system/features/store/presentation/widgets/save_to_firebase_logic.dart';

class RegisterStoreForm extends ConsumerStatefulWidget {
  const RegisterStoreForm({super.key});

  @override
  ConsumerState<RegisterStoreForm> createState() => _RegisterStoreFormState();
}

class _RegisterStoreFormState extends ConsumerState<RegisterStoreForm> {
  late double width;
  late double height;

  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeOwnerController = TextEditingController();
  late var currentLoggedInUser;
  TextEditingController pictureController = TextEditingController();

  @override
  void dispose() {
    storeNameController.dispose();
    storeOwnerController.dispose();
    pictureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;

    currentLoggedInUser = ref.read(currentLoggedInUserControllerProvider);
    // Only set the default value of storeOwnerController is it is empty to prevent overwriting.
    if (storeOwnerController.text == "") {
      storeOwnerController.text = currentLoggedInUser.value!.id!;
    }

    final personalInfoRepo = ref.read(myPersonalInfoRepoProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: MyContainer(
        width: width,
        height: height * 0.56,
        color: myColorScheme.surface.withAlpha(180),
        clipBehavior: Clip.antiAlias,
        child: Column(
          spacing: 8,
          children: [
            SizedBox(height: 16),
            MyText(
              text: "Register Store Form",
              fontSize: kDefaultFontSize + 8,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(height: 16),

            MyTextfield(
              labelText: "Store Name",
              prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedStore01),
              textController: storeNameController,
              borderColor: myColorScheme.onSurfaceVariant,
              focusBorderWidth: .8,
              borderRadius: 8,
            ),
            MyTextfield(
              labelText: "Store Owner",
              prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser02),
              textController: storeOwnerController,
              focusBorderWidth: .8,
              borderColor: myColorScheme.onSurfaceVariant,
              borderRadius: 8,
            ),
            MyTextfield(
              labelText: "Picture",
              prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedImage01),
              textController: pictureController,
              focusBorderWidth: .8,
              borderColor: myColorScheme.onSurfaceVariant,
              borderRadius: 8,
            ),
            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                MyButton(
                  buttonText: (!isAnyOfTheFieldsFilled()) ? "Cancel" : "Clear",
                  buttonTextColor: myColorScheme.inverseSurface,
                  color: myColorScheme.surfaceContainer,
                  borderColor: myColorScheme.surfaceContainer,
                  enableShadow: false,
                  widthPercentage: .3,
                  onTap: () {
                    // if any of the fields does not have been inputted, just cancel everything
                    if (!isAnyOfTheFieldsFilled()) {
                      Navigator.pop(context);
                      return;
                    }

                    myAlertDialogue(
                      context: context,
                      alertTitle: "Comfirm to clear the fields?",
                      alertContent:
                          "This will remove all the text you have inputted.",
                      onApprovalPressed: () {
                        storeNameController.clear();
                        storeOwnerController.clear();
                        pictureController.clear();
                        Navigator.pop(context);
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    );
                  },
                ),
                MyButton(
                  buttonText: "Save",
                  buttonShadowColor: myColorScheme.primary,
                  widthPercentage: .4,
                  onTap: () {
                    saveLogic(context, currentLoggedInUser, personalInfoRepo);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void saveLogic(
    BuildContext context,
    AsyncValue<PersonalInfo?> currentLoggedInUser,
    MyPersonalInfoRepository personalInfoRepo,
  ) {
    return myAlertDialogue(
      context: context,
      alertTitle: "Confirm to save?",
      alertContent: "Confirming will save the data to the database.",
      onApprovalButtonText: "Confirm Save",
      onApprovalPressed: () async {
        if (await ref
            .read(myPersonalInfoRepoProvider)
            .doesThisRecordExist(recordID: storeOwnerController.text)) {
          log(storeNameController.text);
          log(storeOwnerController.text);
          log(pictureController.text);

          // Save store info
          saveToFirebase(
            ref: ref,
            personalInfoRepo: ref.read(myPersonalInfoRepoProvider),
            storeName: storeNameController.text,
            storeOwner: storeOwnerController.text,
            picture: pictureController.text,
          );

          // Update user info
          List<String> ownedStores = [...currentLoggedInUser.value!.ownerAt];

          final newlyRegisteredStore = await ref
              .read(storeInfoRepoRefProvider)
              .getByQuery(field: "storeName", value: storeNameController.text);
          ownedStores.add(newlyRegisteredStore.last.id!);
          log("ownedStores: $ownedStores");

          PersonalInfo updatedUserOwnedStores = currentLoggedInUser.value!
              .copyWith(
                ownerAt: ownedStores,
                currentStoreInView: newlyRegisteredStore.last.id!,
              );
          log("updatedUserOwnedStores: ${updatedUserOwnedStores.ownerAt}");

          personalInfoRepo.update(
            currentLoggedInUser.value!.id!,
            updatedUserOwnedStores,
          );

          // Refresh the current user data
          ref.invalidate(currentLoggedInUserControllerProvider);

          Navigator.pop(context);
          Navigator.pop(context);
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }

  bool isAnyOfTheFieldsFilled() {
    bool isNameControllerNotEmpty = storeNameController.text != ""; // nay sulod
    bool isStoreOwnerControllerNotEmptyNorUsingDefaultValue =
        (storeOwnerController.text != "" &&
        storeOwnerController.text != currentLoggedInUser.value!.id);
    bool isPictureControllerNotEmpty = pictureController.text != "";

    if (isNameControllerNotEmpty ||
        isStoreOwnerControllerNotEmptyNorUsingDefaultValue ||
        isPictureControllerNotEmpty) {
      log(
        "isStoreOwnerControllerNotEmptyNorUsingDefaultValue: $isStoreOwnerControllerNotEmptyNorUsingDefaultValue",
      );
      log("empty string ra: true");
      return true;
    } else {
      log("empty string ra: false");
      return false;
    }
  }
}
