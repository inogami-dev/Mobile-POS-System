import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/core/widgets/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/bottom_sheet_decorated.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/date_picker.dart';
import 'package:pos_system/core/widgets/my_snackbar.dart';
import 'package:pos_system/core/widgets/navigator.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/inventory/presentation/state_management/all_listed_products.dart';
import 'package:pos_system/features/inventory/presentation/state_management/decoded_image_cache.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/helpers/form_save_product_logic.dart';
import 'package:pos_system/features/products/presentation/helpers/form_update_product_logic.dart';
import 'package:pos_system/features/products/presentation/state_management/picked_image_value.dart';
import 'package:pos_system/features/products/presentation/state_management/single_scan_value.dart';
import 'package:pos_system/features/products/presentation/widgets/product_image_picker.dart';
import 'package:pos_system/features/products/presentation/widgets/scanner.dart';

class AddProductForm extends ConsumerStatefulWidget {
  final ProductModel? product;
  const AddProductForm({super.key, this.product});

  @override
  ConsumerState<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends ConsumerState<AddProductForm> {
  // Object Fields
  String? productID;
  late String storeID;
  late String registeredOn;
  late String registeredBy;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  DateTime? expirationDate;
  String scannedBarcode = "";
  String pickedProductImage = "";
  bool isAnExistingProduct = false;

  // This will cached the pickedImage to avoid the issue of the pickedImage blinking every time a repaint occurs.
  Uint8List? decodedPickedImage;

  // For Comparison when updating an existing product
  String xpicture = "";
  String xbarCode = "";
  String xname = "";
  String xdescription = "";
  double xprice = 0;
  int xquantity = 0;
  String? xexpirationDate = "";

  // Layout Fields
  late ColorScheme myColorScheme;
  late double width;
  late double height;
  late String pageTitle;
  late String buttonText;
  Color? buttonColor = Colors.grey.shade600;
  bool hasAlreadyPressedSubmit = false;

  @override
  void initState() {
    super.initState();
    // Update
    if (widget.product != null) {
      isAnExistingProduct = true;
      setXFields(widget.product!);
      productID = widget.product!.id;
      storeID = widget.product!.storeId;
      registeredOn = widget.product!.registeredOn;
      registeredBy = widget.product!.registeredBy;
      pickedProductImage = widget.product!.picture;
      scannedBarcode = widget.product!.barCode;
      productNameController.text = widget.product!.name;
      productDescriptionController.text = widget.product!.description;
      productPriceController.text = widget.product!.price.toString();
      productQuantityController.text = widget.product!.quantity.toString();
      expirationDate = DateTime.tryParse(widget.product!.expirationDate!);
      pageTitle = "Edit Product";
      buttonText = "Update Product";
    }
    // Add New Product
    else {
      pageTitle = "Add Product";
      buttonText = "Save Product";
      buttonColor = Colors.grey.shade600;
    }

    // Listeners for changes (for products that already existed)
    productNameController.addListener(isToBeUpdatedProductBeenAltered);
    productDescriptionController.addListener(isToBeUpdatedProductBeenAltered);
    productQuantityController.addListener(isToBeUpdatedProductBeenAltered);
    productPriceController.addListener(isToBeUpdatedProductBeenAltered);
  }

  @override
  void dispose() {
    productNameController.dispose();
    productDescriptionController.dispose();
    productPriceController.dispose();
    productQuantityController.dispose();
    productNameController.removeListener(isToBeUpdatedProductBeenAltered);
    productDescriptionController.removeListener(
      isToBeUpdatedProductBeenAltered,
    );
    productQuantityController.removeListener(isToBeUpdatedProductBeenAltered);
    productPriceController.removeListener(isToBeUpdatedProductBeenAltered);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    myColorScheme = Theme.of(context).colorScheme;

    // This is for if it is an OLD Product (already registered before)
    // if (widget.product == null) {
    //   scannedBarcode = ref.watch<String>(singleScanValueProvider);
    //   pickedProductImage = ref.watch<String>(pickedImageValueProvider);
    // }

    ref.listen<String>(pickedImageValueProvider, (previous, newImage) {
      if (newImage.isNotEmpty) {
        setState(() {
          pickedProductImage = newImage;
          if (xpicture != pickedProductImage) {
            // xpicture = newImage;
            buttonColor = null;
          }

          // Store a decoded version of the picked image everytime a new image was picked.
          decodedPickedImage = MyImageProcessor.decodeStringToUint8List(
            pickedProductImage,
          );
        });
      }
    });

    // 1. SAFELY LISTEN FOR BARCODE SCANS
    ref.listen<String>(singleScanValueProvider, (previous, newBarcode) {
      if (newBarcode.isNotEmpty && widget.product == null) {
        // 2. Safely search for the product without crashing
        final productList = ref.read(allListedProductsProvider).value ?? [];

        // Use .where().firstOrNull instead of firstWhere to avoid StateError crashes
        final foundProduct = productList
            .where((p) => p.barCode == newBarcode)
            .firstOrNull;

        buttonColor = null;

        if (foundProduct != null) {
          // 3. Update the UI and Controllers safely!
          setState(() {
            isAnExistingProduct = true;
            setXFields(foundProduct);

            productID = foundProduct.id;
            storeID = foundProduct.storeId;
            registeredOn = foundProduct.registeredOn;
            registeredBy = foundProduct.registeredBy;
            scannedBarcode = newBarcode;
            pickedProductImage = foundProduct.picture;

            // Auto-fill the form fields
            productNameController.text = foundProduct.name;
            productDescriptionController.text = foundProduct.description;
            productPriceController.text = foundProduct.price.toString();
            productQuantityController.text = foundProduct.quantity.toString();

            if (foundProduct.expirationDate != null &&
                foundProduct.expirationDate!.isNotEmpty) {
              expirationDate = DateTime.tryParse(foundProduct.expirationDate!);
            }

            // Change the UI text to update mode
            pageTitle = "Product Found (Update)";
            buttonText = "Update Inventory";
          });

          log("Auto-filled existing product: ${foundProduct.name}");
        } else {
          // It's a new product, just set the barcode
          setState(() {
            scannedBarcode = newBarcode;
          });
        }
      }
    });

    bool isBarcodeScanned = scannedBarcode.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent, //
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: MyDecoratedBottomSheet(
              width: width,
              child: Column(
                spacing: 8,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                    child: MyText(
                      text: pageTitle,
                      fontSize: kDefaultFontSize + 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      MyNavigator.goTo(
                        context,
                        MyProductImagePicker(isOval: false),
                      );
                    },
                    child: MyContainer(
                      width: width * 0.8,
                      height: height * 0.25,
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
                      clipBehavior: Clip.hardEdge,
                      borderRadius: 16,
                      color: myColorScheme.surfaceContainerHighest,
                      borderColor: myColorScheme.primaryFixed,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (pickedProductImage.isEmpty)
                              ? HugeIcon(
                                  icon: HugeIcons.strokeRoundedImage01,
                                  size: 32,
                                  color: myColorScheme.onSurfaceVariant,
                                )
                              : Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      10,
                                    ),
                                    child: MyImageDisplayer(
                                      displaySize: width * 0.8,
                                      isOval: false,
                                      imageInBase64Format: decodedPickedImage,
                                    ),
                                  ),
                                ),
                          SizedBox(width: 8),
                          MyText(
                            fontSize: kDefaultFontSize - 2,
                            text: (pickedProductImage.isEmpty)
                                ? "Select an Image"
                                : "Selected Product Image",
                          ),
                          // SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      MyNavigator.goTo(context, MyScanner());
                    },
                    child: MyContainer(
                      width: width * 0.8,
                      height: 45,
                      padding: EdgeInsets.only(left: 16),
                      margin: EdgeInsets.symmetric(vertical: 2),
                      borderRadius: 50,
                      color: myColorScheme.surfaceContainerHighest,
                      borderColor: myColorScheme.primaryFixed,
                      clipBehavior: Clip.hardEdge,
                      child: Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedBarCode01,
                            size: 32,
                            color: myColorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: MyText(
                              text: (isBarcodeScanned)
                                  ? scannedBarcode
                                  : "Scan Barcode",
                              textOverFlow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      ),
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
                    textInputType: TextInputType.number,
                    prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedMoney04),
                    textController: productPriceController,
                  ),
                  MyTextfield(
                    labelText: "Quantity",
                    textInputType: TextInputType.number,
                    prefixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedTextNumberSign,
                    ),
                    textController: productQuantityController,
                  ),
                  expirationDateButton(context),
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
                            buttonText: buttonText,
                            color: buttonColor,
                            onTap: () async {
                              if (hasAlreadyPressedSubmit) {
                                showMyAnimatedSnackBar(
                                  context: context,
                                  dataToDisplay:
                                      "The button has already been pressed. Please wait for the process to complete.",
                                );
                                return;
                              }
                              hasAlreadyPressedSubmit = true;

                              if (pickedProductImage.isEmpty ||
                                  scannedBarcode.isEmpty ||
                                  productNameController.text.isEmpty ||
                                  productDescriptionController.text.isEmpty ||
                                  productPriceController.text.isEmpty ||
                                  productQuantityController.text.isEmpty) {
                                showMyAnimatedSnackBar(
                                  context: context,
                                  dataToDisplay:
                                      "Do not leave empty fields. \n\n(Except for the Expiration Date as you can leave it as is if the product has no expiration date.)",
                                );
                                return;
                              }

                              if (isAnExistingProduct) {
                                log("Yup1");
                                if (isToBeUpdatedProductBeenAltered()) {
                                  log("Yup2");
                                  await updateProductLogic(
                                    context,
                                    ref: ref,
                                    product: ProductModel(
                                      id: productID,
                                      name: productNameController.text.trim(),
                                      queryName: productNameController.text
                                          .trim()
                                          .toLowerCase(),
                                      storeId: storeID,
                                      description: productDescriptionController
                                          .text
                                          .trim(),
                                      barCode: scannedBarcode.trim(),
                                      price: double.parse(
                                        productPriceController.text.trim(),
                                      ),
                                      quantity: int.parse(
                                        productQuantityController.text.trim(),
                                      ),
                                      picture: pickedProductImage,
                                      expirationDate: (expirationDate != null)
                                          ? expirationDate.toString()
                                          : "",
                                      registeredOn: registeredOn,
                                      registeredBy: registeredBy,
                                    ),
                                  );

                                  hasAlreadyPressedSubmit = false;

                                  // To update the cached image
                                  if (pickedProductImage !=
                                      widget.product!.picture) {
                                    ref
                                        .read(
                                          myDecodedImageCacheProvider.notifier,
                                        )
                                        .addImageToDecode(pickedProductImage);
                                    ref
                                        .read(
                                          myDecodedImageCacheProvider.notifier,
                                        )
                                        .removeDecodedImage(
                                          widget.product!.picture,
                                        );
                                  }
                                }
                              } else {
                                log("Nope");
                                await saveProductLogic(
                                  context,
                                  ref: ref,
                                  productName: productNameController.text,
                                  productDescription:
                                      productDescriptionController.text,
                                  productPrice: productPriceController.text,
                                  productQuantity:
                                      productQuantityController.text,
                                  expirationDate: (expirationDate != null)
                                      ? expirationDate.toString()
                                      : "",
                                  scannedBarcode: scannedBarcode,
                                  pickedProductImage: pickedProductImage,
                                );

                                ref
                                    .read(myDecodedImageCacheProvider.notifier)
                                    .addImageToDecode(pickedProductImage);
                                hasAlreadyPressedSubmit = false;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget expirationDateButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        expirationDate = await myDatePicker(context);
        log(expirationDate.toString());
        setState(() {});
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
                      : "No Expiration  (or Pick Exp Date)",
                ),
              ],
            ),
        //   ],
        // ),
      ),
    );
  }

  /// This is for the Update not when adding new Product
  /// To prevent calling firebase whenever there is no change when updating.
  bool isToBeUpdatedProductBeenAltered() {
    final tempExpDate = expirationDate ?? "";
    if (widget.product != null) {
      log("01: ${productNameController.text}");
      log("02: ${xname}");
      log("11: ${productDescriptionController.text}");
      log("12: ${xdescription}");
      log("21: ${productPriceController.text}");
      log("22: ${xprice.toString()}");
      log("31: ${productQuantityController.text}");
      log("32: ${xquantity.toString()}");
      log("41: ${tempExpDate}");
      log("42: ${xexpirationDate}");
      log("51: ${scannedBarcode}");
      log("52: ${xbarCode}");
      log("61: ${pickedProductImage.length}");
      log("62: ${xpicture.length}");
    }
    if (pickedProductImage != xpicture ||
        scannedBarcode != xbarCode ||
        productNameController.text != xname ||
        productDescriptionController.text != xdescription ||
        productPriceController.text != xprice.toString() ||
        productQuantityController.text != xquantity.toString() ||
        tempExpDate != xexpirationDate) {
      setState(() => buttonColor = null);
      return true;
    }
    if (isAnExistingProduct) {
      setState(() => buttonColor = myColorScheme.outlineVariant);
    } else {
      setState(() => buttonColor = null);
    }

    showMyAnimatedSnackBar(
      context: context,
      dataToDisplay: "No changes detected. Update is aborted.",
    );
    hasAlreadyPressedSubmit = false;

    return false;
  }

  void setXFields(ProductModel product) {
    xpicture = widget.product?.picture ?? product.picture;
    xname = widget.product?.name ?? product.name;
    xdescription = widget.product?.description ?? product.description;
    xprice = widget.product?.price ?? product.price;
    xquantity = widget.product?.quantity ?? product.quantity;
    xbarCode = widget.product?.barCode ?? product.barCode;
    xexpirationDate = widget.product?.expirationDate ?? product.expirationDate;
  }
}
