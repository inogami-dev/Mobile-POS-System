import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/bottom_sheet_decorated.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/date_picker.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/page_navigator.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/products/presentation/state_management/picked_image_value.dart';
import 'package:pos_system/features/products/presentation/state_management/single_scan_value.dart';
import 'package:pos_system/features/products/presentation/widgets/product_image_picker.dart';
import 'package:pos_system/features/products/presentation/widgets/scanner.dart';

class AddProductSheet extends ConsumerStatefulWidget {
  const AddProductSheet({super.key});

  @override
  ConsumerState<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends ConsumerState<AddProductSheet> {
  // Object Fields
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productRriceController = TextEditingController();
  DateTime? expirationDate;
  late String scannedBarcode;
  late String pickedProductImage;

  // Layout Fields
  late ColorScheme myColorScheme;
  late double width;
  late double height;

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productRriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    myColorScheme = Theme.of(context).colorScheme;
    scannedBarcode = ref.watch<String>(singleScanValueProvider);
    pickedProductImage = ref.watch<String>(pickedImageValueProvider);
    bool isBarcodeScanned = scannedBarcode.isNotEmpty;

    return StatefulBuilder(
      builder: (context, StateSetter setModalState) {
        return MyDecoratedBottomSheet(
          width: width,
          // height: height * 0.56,
          child: Column(
            spacing: 8,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                child: MyText(
                  text: "Add a Product",
                  fontSize: kDefaultFontSize + 8,
                  fontWeight: FontWeight.w800,
                ),
              ),

              MyTextfield(
                labelText: "Product Name",
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedPackage),
                textController: productNameController,
              ),
              MyTextfield(
                labelText: "Product Description",
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedText),
                textController: productDescriptionController,
              ),
              MyTextfield(
                labelText: "Price",
                prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMoney04),
                textController: productRriceController,
              ),
              GestureDetector(
                onTap: () {
                  MyNavigator.goTo(context, MyScanner());
                },
                child: MyContainer(
                  width: width * 0.8,
                  height: 50,
                  padding: EdgeInsets.only(left: 16),
                  borderRadius: 50,
                  color: myColorScheme.surfaceContainerHighest,
                  borderColor: myColorScheme.primaryFixed,
                  child: Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedBarCode01,
                        size: 32,
                        color: myColorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 8),
                      MyText(
                        text: (isBarcodeScanned)
                            ? scannedBarcode
                            : "Scan Barcode",
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  MyNavigator.goTo(context, MyProductImagePicker());
                },
                child: MyContainer(
                  width: width * 0.8,
                  height: 50,
                  padding: EdgeInsets.only(left: 16),
                  borderRadius: 50,
                  color: myColorScheme.surfaceContainerHighest,
                  borderColor: myColorScheme.primaryFixed,
                  child: Row(
                    children: [
                      (pickedProductImage.isEmpty)
                          ? HugeIcon(
                              icon: HugeIcons.strokeRoundedImage01,
                              size: 32,
                              color: myColorScheme.onSurfaceVariant,
                            )
                          : MyImageDisplayer(
                              displaySize: 32,
                              imageInBase64Format:
                                  MyImageProcessor.decodeStringToUint8List(
                                    pickedProductImage,
                                  ),
                            ),
                      SizedBox(width: 8),
                      MyText(
                        text: (pickedProductImage.isEmpty)
                            ? "Select an Image"
                            : "Selected Product Image",
                      ),
                    ],
                  ),
                ),
              ),
              expirationDateButton(context, setModalState),
              SizedBox(height: 16),
              Container(
                width: width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    MyButton(
                      buttonText: "Cancel",
                      isUsedAsAbortButton: true,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: MyButton(
                        buttonText: "Save Product",
                        onTap: () {
                          showMyAnimatedSnackBar(
                            context: context,
                            dataToDisplay:
                                "Name: ${productNameController.text} \nDescription: ${productDescriptionController.text} \nPrice: ${productRriceController.text} \nExpiration Date: ${expirationDate.toString()}",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget expirationDateButton(BuildContext context, StateSetter setModalState) {
    return GestureDetector(
      onTap: () async {
        expirationDate = await myDatePicker(context);
        log(expirationDate.toString());
        setModalState(() {});
      },
      child: MyContainer(
        width: width * 0.8,
        height: 50,
        padding: EdgeInsets.only(left: 16),
        borderRadius: 50,
        color: myColorScheme.surfaceContainerHighest,
        borderColor: myColorScheme.primaryFixed,
        child:
            // Column(
            //   // mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     MyText(text: "Expiration Date"),
            Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendar05,
                  size: 32,
                  color: myColorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 8),
                MyText(
                  text: (expirationDate != null)
                      ? MyDateFormatter.formatDate(
                          dateTimeInString: expirationDate.toString(),
                        )
                      : "Pick Exp Date",
                ),
              ],
            ),
        //   ],
        // ),
      ),
    );
  }
}
