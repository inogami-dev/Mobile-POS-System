import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/scrollbar.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/cashier/data/model/scanned_item.dart';
import 'package:pos_system/features/cashier/presentation/widgets/particulars_area_mini_widgets.dart/popup.dart';

class ParticularsArea extends ConsumerWidget {
  const ParticularsArea({
    super.key,
    required this.scrollController,
    required this.height,
    required this.scannedItems,
    required this.myColorScheme,
    required this.width,
  });

  final ScrollController scrollController;
  final double height;
  final List<ScannedItem> scannedItems;
  final ColorScheme myColorScheme;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: MyScrollBar(
        controller: scrollController,
        padding: EdgeInsets.only(bottom: height * 0.1),
        opacityPercentage: 0.56,
        child: ListView.builder(
          controller: scrollController,
          itemCount: scannedItems.length,
          padding: EdgeInsets.only(top: 8, bottom: (height * 0.16)),
          itemBuilder: (context, index) {
            return MyContainer(
              padding: EdgeInsets.all(0),
              enableShadow: false,
              margin: EdgeInsets.only(left: 24, right: 24, bottom: 4),
              borderColor: myColorScheme.outlineVariant,
              child: GestureDetector(
                onTap: MyParticularsPopup.toEdit(
                  context,
                  ref: ref,
                  productBarcode: scannedItems[index].id!,
                  initQuantity: scannedItems[index].quantity.toInt(),
                ),
                onLongPress: MyParticularsPopup.toDelete(
                  context,
                  ref: ref,
                  productBarcode: scannedItems[index].id!,
                ),
                child: ListTile(
                  title: Container(
                    alignment: Alignment.centerLeft,
                    width: width * 0.77,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          fontSize: kDefaultFontSize + 2,
                          fontWeight: FontWeight.w600,
                          textOverFlow: TextOverflow.ellipsis,
                          text: scannedItems[index].name,
                          // +
                          // "jsdksh skjbese kfjebksjbfek kjn",
                        ),
                        FittedBox(
                          child: Row(
                            children: [
                              MyText(
                                fontSize: kDefaultFontSize - 4,
                                color: myColorScheme.outline,
                                text: "#:",
                              ),
                              MyText(
                                fontSize: kDefaultFontSize - 4,
                                color: myColorScheme.outline,
                                text: "${scannedItems[index].id}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                    width: width * 0.23,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            MyText(
                              fontSize: kDefaultFontSize + 2,
                              color: myColorScheme.outline,
                              letterSpacing: 1.5,
                              text: "₱ ",
                            ),
                            FittedBox(
                              child: MyText(
                                fontSize: kDefaultFontSize + 2,
                                fontWeight: FontWeight.w500,
                                text:
                                    "${(scannedItems[index].price * scannedItems[index].quantity)}",
                              ),
                            ),
                          ],
                        ),
                        FittedBox(
                          child: Row(
                            children: [
                              MyText(
                                color: myColorScheme.outline,
                                text: "Qty:  ",
                              ),
                              MyText(
                                fontWeight: FontWeight.w600,
                                fontFamily: "",
                                text:
                                    "${scannedItems[index].quantity.toInt()} ",
                              ),
                              MyText(
                                color: myColorScheme.outline,
                                text: " Ph₱:  ",
                              ),
                              MyText(
                                fontWeight: FontWeight.w600,
                                text: "${scannedItems[index].price}",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
