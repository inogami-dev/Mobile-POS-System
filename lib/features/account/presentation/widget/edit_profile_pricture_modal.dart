// a separate section for editing user profile picture
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_repo_provider.dart';

/// A bottom sheet to update profile picture
void editProfilePicture({
  required BuildContext context,
  required WidgetRef ref,
  required ColorScheme myColorScheme,
  required PersonalInfo loggedInUserInfo,
  required double width,
}) {
  late double spacing;
  String? _selectedNewPicture = null;

  showMyBottomSheet(
    context: context,
    child: StatefulBuilder(
      builder: (context, StateSetter setModalState) {
        setModalState(() => spacing = (_selectedNewPicture == null) ? 40 : 8);
        return MyContainer(
          height: MyDimensions.getHeight(context) * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: spacing),
              GestureDetector(
                onTap: () async {
                  String pickedImageBase64 =
                      await MyImageProcessor.myImagePicker(ImageSource.gallery);

                  // 2. Prevent updating if the user cancelled the picker
                  if (pickedImageBase64.isNotEmpty) {
                    // 3. Use setModalState to rebuild ONLY the bottom sheet
                    setModalState(() {
                      _selectedNewPicture = pickedImageBase64;
                    });
                  }
                },
                child: Container(
                  padding: (_selectedNewPicture == null)
                      ? EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                      : EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: myColorScheme.surfaceContainerHigh,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: (_selectedNewPicture == null)
                      ? MyText(text: "Select an image.")
                      : MyImageDisplayer(
                          displaySize: width * 0.3,
                          imageInBase64Format:
                              MyImageProcessor.decodeStringToUint8List(
                                _selectedNewPicture ?? "",
                              ),
                        ),
                ),
              ),
              // SizedBox(height: spacing),
              Spacer(),

              Row(
                spacing: 8,
                children: [
                  MyButton(
                    buttonText: "Cancel",
                    isUsedAsAbortButton: true,
                    widthPercentage: .35,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  MyButton(
                    buttonText: "Save Changes",
                    color: (_selectedNewPicture == null) ? Colors.grey : null,
                    widthPercentage: .56,
                    onTap: () {
                      if (_selectedNewPicture == null) {
                        showMyAnimatedSnackBar(
                          context: context,
                          dataToDisplay: "Please select an image first.",
                        );
                      } else {
                        myAlertDialogue(
                          context: context,
                          alertTitle: "Confirm change?",
                          alertContent:
                              "Are you sure you want to change your profile picture?",
                          onApprovalPressed: () {
                            ref
                                .read(myPersonalInfoRepoProvider)
                                .update(
                                  loggedInUserInfo.id!,
                                  loggedInUserInfo.copyWith(
                                    picture: _selectedNewPicture!,
                                  ),
                                );
                            // refresh this state
                            ref.invalidate(
                              currentLoggedInUserControllerProvider,
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    ),
  );
}
