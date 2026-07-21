import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/products/presentation/state_management/picked_image_value.dart';

class MyProductImagePicker extends ConsumerStatefulWidget {
  /// [isOval] indicates if the [MyProductImagePicker] should be circular or not.
  final bool isOval;
  const MyProductImagePicker({super.key, this.isOval = true});

  @override
  ConsumerState<MyProductImagePicker> createState() =>
      _MyProductImagePickerState();
}

class _MyProductImagePickerState extends ConsumerState<MyProductImagePicker> {
  late double width;
  late double height;
  late ColorScheme myColorScheme;

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    myColorScheme = Theme.of(context).colorScheme;
    String pickedImage = ref.watch(pickedImageValueProvider);
    double effectiveBorderRadius = (widget.isOval) ? 100 : 16;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(vertical: 32),
          // color: myColorScheme.surfaceContainerHighest,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              MyContainer(
                padding: EdgeInsets.symmetric(vertical: 16),
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showMyAnimatedSnackBar(
                          context: context,
                          dataToDisplay:
                              "Please click either of the two buttons below to pick an image. \n\nGallery or Camera.",
                        );
                      },
                      child: MyContainer(
                        width: width * 0.56,
                        height: width * 0.56,
                        padding: EdgeInsets.all(4),
                        borderColor: (pickedImage.isEmpty)
                            ? Colors.transparent
                            : myColorScheme.outline.withAlpha(200),
                        borderRadius: effectiveBorderRadius,
                        child: MyContainer(
                          width: width * 0.56,
                          height: width * 0.56,
                          padding: EdgeInsets.all(0),
                          clipBehavior: Clip.hardEdge,
                          borderColor: myColorScheme.outline.withAlpha(200),
                          borderRadius: effectiveBorderRadius - 4,
                          child: MyImageDisplayer(
                            displaySize: width * 0.56,
                            isOval: false,
                            imageInBase64Format:
                                MyImageProcessor.decodeStringToUint8List(
                                  pickedImage,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    (ref.read(pickedImageValueProvider).isEmpty)
                        ? MyText(text: "Select the image you want to use.")
                        : SizedBox(),
                    SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        spacing: 8,
                        children: [
                          pickOptionButton(
                            pickFrom: ImageSource.gallery,
                            buttonText: "Gallery",
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedImage01,
                              size: 32,
                              color: myColorScheme.onSurfaceVariant,
                            ),
                          ),
                          pickOptionButton(
                            pickFrom: ImageSource.camera,
                            buttonText: "Camera",
                            icon: HugeIcon(
                              icon: HugeIcons.strokeRoundedCamera01,
                              size: 32,
                              color: myColorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 128),
              Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  MyButton(
                    isUsedAsAbortButton: true,
                    buttonText: "Cancel",
                    onTap: () {
                      ref
                          .read(pickedImageValueProvider.notifier)
                          .removeCachedImage();
                      Navigator.pop(context);
                    },
                  ),
                  MyButton(
                    widthPercentage: 0.6,
                    buttonText: "Set as Product Image",
                    onTap: () {
                      if (pickedImage.isEmpty) {
                        showMyAnimatedSnackBar(
                          context: context,
                          dataToDisplay: "No image picked..",
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded pickOptionButton({
    required String buttonText,
    required HugeIcon icon,
    required ImageSource pickFrom,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          ref
              .read(pickedImageValueProvider.notifier)
              .setPickedImage(await MyImageProcessor.myImagePicker(pickFrom));
        },
        child: MyContainer(
          width: width * 0.8,
          height: 45,
          padding: EdgeInsets.only(left: 16),
          borderRadius: 50,
          color: myColorScheme.surfaceContainerHighest,
          borderColor: myColorScheme.primaryFixed,
          child: Row(
            children: [
              icon,
              SizedBox(width: 8),
              MyText(text: buttonText),
            ],
          ),
        ),
      ),
    );
  }
}
