import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/utilities/image_displayer.dart';
import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class MyDropdownMenuButton extends StatefulWidget {
  /// The first in the list should be a default or no value yet (e.g. "No Role")
  /// Because I program this dropdown to display the items[0] to look like NO VALUE YET
  final List<String> items;
  final Icon icon;
  final String? hintText;
  final String initialValue;
  final Function(String?) onChanged;
  final double widthPercentage;
  final double heightPercentage;
  final bool isLeadingIconVisible;

  /// This is for the case when you want to display text with image in the dropdown item,
  /// the key should be the text and the value should be the base64 string of the image
  /// `"storeName:base64String"`
  final bool isTextWithImage;
  final Map<String, String>? itemWithImage;

  const MyDropdownMenuButton({
    super.key,
    required this.items,
    required this.initialValue,
    this.hintText,
    required this.onChanged,
    this.icon = const Icon(Icons.info_outline_rounded, size: 32),
    this.widthPercentage = 0.8,
    this.heightPercentage = 0.07,
    this.isLeadingIconVisible = true,
    this.isTextWithImage = false,
    this.itemWithImage,
  });

  @override
  State<MyDropdownMenuButton> createState() => _MyDropdownMenuButtonState();
}

class _MyDropdownMenuButtonState extends State<MyDropdownMenuButton> {
  @override
  Widget build(BuildContext context) {
    final myColorSheme = Theme.of(context).colorScheme;

    // Constraint ni
    if (widget.isTextWithImage && widget.itemWithImage == null) {
      throw Exception(
        "itemWithImage cannot be null when isTextWithImage is true",
      );
    }

    return SizedBox(
      width: MyDimensions.getWidth(context) * widget.widthPercentage,
      height: MyDimensions.getHeight(context) * widget.heightPercentage,
      // width: MyDimensions.getWidth(context)
      // height: MyDimensions.getHeight(context) * 0.2,
      child: DropdownButtonFormField<String>(
        initialValue: widget.initialValue,
        menuMaxHeight: MyDimensions.getHeight(context) * 0.55,
        padding: EdgeInsets.all(0),
        // dropdownColor: Colors.blue[50],
        dropdownColor: myColorSheme.surfaceContainer,
        hint: (widget.hintText == null) ? null : Text(widget.hintText!),
        decoration: InputDecoration(
          icon: (widget.isLeadingIconVisible) ? widget.icon : null,
          // iconColor: Colors.blue.shade200,
          iconColor: myColorSheme.primaryFixed,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.5,
              color: myColorSheme.onSecondaryFixedVariant,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1,
              //  color: myColorSheme.primaryFixed,
              color: myColorSheme.onSecondaryFixedVariant,
            ),
          ),
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: (widget.isTextWithImage)
                    ? Row(
                        children: [
                          MyImageDisplayer(
                            base64ImageString:
                                MyImageProcessor.decodeStringToUint8List(
                                  widget.itemWithImage![item]!,
                                ),
                          ),
                          MyText(text: item),
                        ],
                      )
                    : MyText(text: item),
              ),
            )
            .toList(),
        // onChanged: (item) => setState(() {
        //   _selectedItem = item!;
        // }),
        onChanged: widget.onChanged,
      ),
    );
  }
}
