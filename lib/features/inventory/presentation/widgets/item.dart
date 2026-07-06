import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/hero.dart';
import 'package:pos_system/core/widgets/navigator.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/inventory/presentation/widgets/item_hero.dart';
import 'package:pos_system/features/products/data/model/product_model.dart';

class MyItem extends StatelessWidget {
  final double? width;
  final double? height;
  // final String imageString;
  final ProductModel product;
  const MyItem({super.key, this.width, this.height, required this.product});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.45;
    double height = MediaQuery.of(context).size.height * 0.08;
    final myColorScheme = Theme.of(context).colorScheme;

    final doesProductExpire =
        product.expirationDate != null && product.expirationDate!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ItemHero(heroTag: product.id!),
        //   ),
        // );
        MyNavigator.goTo(
          context,
          ItemHero(heroTag: product.id!),
          animationType: MyAnimationType.fade,
        );
      },
      child: MyHero(
        tag: product.id!,
        child: MyContainer(
          width: width,
          height: height,
          padding: EdgeInsets.all(0),
          clipBehavior: Clip.hardEdge,
          borderColor: myColorScheme.outlineVariant,
          // color: Colors.blue,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            children: [
              // Placeholder(),
              Positioned.fill(
                child: MyImageDisplayer(
                  isOval: false,
                  imageInBase64Format: MyImageProcessor.decodeStringToUint8List(
                    product.picture,
                  ),
                ),
              ),
              Positioned(
                top: 2.5,
                right: 2.5,
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationDiamond,
                  color: myColorScheme.outlineVariant,
                ),
              ),
              Positioned(
                bottom: -0.5,
                // left: 2.5,
                child: Container(
                  width: width,
                  height: height,
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 2,
                    bottom: 2,
                  ),
                  margin: EdgeInsets.fromLTRB(4, 0, 4, 0),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    // color: Colors.white10,
                    gradient: LinearGradient(
                      colors: [
                        myColorScheme.surfaceDim.withAlpha(10),
                        myColorScheme.surfaceDim.withAlpha(50),
                        myColorScheme.surfaceDim.withAlpha(100),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    // borderRadius: BorderRadius.only(
                    //   bottomLeft: Radius.circular(16),
                    //   bottomRight: Radius.circular(16),
                    // ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: product.name,
                        textOverFlow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                      ),
                      MyText(
                        text: product.description,
                        maxLines: 2,
                        fontSize: kDefaultFontSize - 4,
                        lineHeight: 1.1,
                      ),
                      Spacer(),
                      MyText(
                        text: (doesProductExpire)
                            ? "Exp: ${product.expirationDate}"
                            : "No Expiration",
                        maxLines: 2,
                        fontSize: kDefaultFontSize - 5,
                        lineHeight: 1.1,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 2.5,
                left: 2.5,
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  padding: EdgeInsets.fromLTRB(4, 4, 12, 4),
                  decoration: BoxDecoration(
                    // color: myColorScheme.surface,
                    gradient: LinearGradient(
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
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
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
                    text: "\$${product.price.toStringAsFixed(2)}",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
