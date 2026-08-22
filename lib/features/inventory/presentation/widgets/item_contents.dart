import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/date_formatter.dart';
import 'package:pos_system/core/widgets/image_displayer.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/my_alert_dialog.dart';
import 'package:pos_system/core/widgets/navigator.dart';
import 'package:pos_system/core/widgets/scrollbar.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';
import 'package:pos_system/features/products/presentation/add_product_form.dart';

class MyItemContents extends StatelessWidget {
  final double width;
  final double height;
  final ProductModel product;
  final Uint8List encodedProductImage;
  final bool isExpanded;

  const MyItemContents({
    super.key,
    required this.width,
    required this.height,
    required this.product,
    required this.encodedProductImage,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController descriptioncrollController = ScrollController();
    final myColorScheme = Theme.of(context).colorScheme;

    final doesProductExpire = (product.expirationDate != "");
    // log("Expiration Date: ${product.expirationDate}");
    int baseTintForProductDetailsArea = (isExpanded) ? 80 : 30;

    return MyContainer(
      width: width,
      height: height,
      padding: EdgeInsets.all(0),
      clipBehavior: Clip.hardEdge,
      borderColor: myColorScheme.outlineVariant,
      borderWidth: (isExpanded) ? 1 : 0,
      // color: Colors.blue,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: MyImageDisplayer(
              isOval: false,
              imageInBase64Format: encodedProductImage,
            ),
          ),

          /// Edit Icon
          if (!isExpanded)
            Positioned(
              top: 2.5,
              right: 2.5,
              child: GestureDetector(
                onTap: () {
                  // showMyAnimatedSnackBar(context: context, dataToDisplay: "Test");
                  myAlertDialogue(
                    context: context,
                    alertTitle: "Confirm to Edit Product",
                    alertContent: "Are you sure you want to edit this product?",
                    onApprovalButtonText: "Edit",
                    onApprovalPressed: () {
                      Navigator.pop(context);
                      MyNavigator.goTo(
                        context,
                        AddProductForm(product: product),
                        animationType: MyAnimationType.slideFromBottom,
                      );
                    },
                  );
                },
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedEditTable,
                  color: Colors.white38,
                  size: (isExpanded) ? 32 : 24,
                ),
              ),
            ),

          // Price Tag
          Positioned(
            top: 2.5,
            left: 2.5,
            child: Container(
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.fromLTRB(4, 4, 12, 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    myColorScheme.secondaryContainer.withAlpha(250),
                    myColorScheme.surfaceBright.withAlpha(80),
                    myColorScheme.secondaryContainer.withAlpha(200),
                    myColorScheme.secondaryContainer.withAlpha(160),
                    myColorScheme.secondaryContainer.withAlpha(120),
                    myColorScheme.secondaryContainer.withAlpha(100),
                    myColorScheme.secondaryContainer.withAlpha(80),
                    myColorScheme.secondaryContainer.withAlpha(50),
                    myColorScheme.secondaryContainer.withAlpha(5),
                  ],
                ),
                border: Border.all(
                  color: myColorScheme.outlineVariant,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: MyText(
                text: "₱ ${product.price.toStringAsFixed(2)}",
                fontWeight: FontWeight.w600,
                fontSize: kDefaultFontSize + ((isExpanded) ? 4 : 0),
              ),
            ),
          ),

          // Product Details
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 50),
              curve: Curves.easeInOut,
              width: width,
              height: (isExpanded) ? (height * 0.2) : height,
              padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
              // margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                // color: Colors.black,
                gradient: LinearGradient(
                  colors: [
                    myColorScheme.surfaceDim.withAlpha(
                      baseTintForProductDetailsArea + 50,
                    ),
                    myColorScheme.surfaceDim.withAlpha(
                      baseTintForProductDetailsArea + 50,
                    ),
                    myColorScheme.surfaceDim.withAlpha(
                      baseTintForProductDetailsArea + 100,
                    ),
                    myColorScheme.surfaceDim.withAlpha(
                      baseTintForProductDetailsArea + 135,
                    ),
                    myColorScheme.surfaceDim.withAlpha(
                      baseTintForProductDetailsArea + 175,
                    ),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: (isExpanded)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: product.name,
                    textOverFlow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w600,
                    fontSize: kDefaultFontSize + ((isExpanded) ? 8 : 0),
                  ),
                  Expanded(
                    child: MyScrollBar(
                      controller: descriptioncrollController,
                      padding: EdgeInsets.only(right: -8),
                      isTrackVisible: (isExpanded) ? true : false,
                      isThumbVisible: (isExpanded) ? true : false,
                      child: SingleChildScrollView(
                        controller: descriptioncrollController,
                        child: MyText(
                          text: product.description,
                          maxLines: (isExpanded) ? 10 : 2,
                          // fontSize: kDefaultFontSize - 4,
                          fontSize: kDefaultFontSize + ((isExpanded) ? 0 : -4),
                          lineHeight: 1.1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),

                  if (isExpanded)
                    MyText(
                      text: "Cost: ₱ ${product.cost.toStringAsFixed(2)}",
                      fontSize: kDefaultFontSize - 1.6,
                    ),
                  if (isExpanded)
                    MyText(
                      text: "Category: ${product.category}",
                      fontSize: kDefaultFontSize - 1.6,
                    ),

                  // Spacer(),
                  Row(
                    children: [
                      MyText(
                        text: (doesProductExpire)
                            ? "Exp: ${MyDateFormatter.formatDate(dateTimeInString: product.expirationDate)}"
                            : "No Expiration",
                        maxLines: 2,
                        // fontSize: kDefaultFontSize - 5,
                        fontSize: kDefaultFontSize + ((isExpanded) ? -2 : -5),
                        lineHeight: 1.1,
                      ),
                      Spacer(),
                      Row(
                        spacing: 1,
                        children: [
                          MyText(
                            text: "${product.quantity}",
                            fontSize:
                                kDefaultFontSize + ((isExpanded) ? -2 : -5),
                            fontWeight: product.quantity == 0
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: product.quantity == 0
                                ? myColorScheme.error
                                : myColorScheme.onSurface,
                          ),
                          MyText(
                            text: " left",
                            fontSize:
                                kDefaultFontSize + ((isExpanded) ? -2 : -5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
