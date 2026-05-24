import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
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
  });

  @override
  State<MyDropdownMenuButton> createState() => _MyDropdownMenuButtonState();
}

class _MyDropdownMenuButtonState extends State<MyDropdownMenuButton> {
  // List<String> items = ["No Role", "Admin", "Social Service", "Home Life"];

  @override
  Widget build(BuildContext context) {
    final myColorSheme = Theme.of(context).colorScheme;

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
        dropdownColor: myColorSheme.surfaceBright,
        hint: (widget.hintText == null) ? null : Text(widget.hintText!),
        decoration: InputDecoration(
          icon: (widget.isLeadingIconVisible) ? widget.icon : null,
          // iconColor: Colors.blue.shade200,
          iconColor: myColorSheme.primaryFixed,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 2.5,
              color: myColorSheme.primaryFixed,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              width: 1.5,
              color: myColorSheme.primaryFixed,
            ),
          ),
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                // (deletable) old code
                // child: Text(
                //   item,
                //   style: TextStyle(
                //     // this ensures that the first item should means no value
                //     fontStyle:
                //         // (item == widget.initialValue && item == "No Role")
                //         (item == widget.items[0])
                //         ? FontStyle.italic
                //         : FontStyle.normal,
                //     color:
                //         // (item == widget.initialValue && item == "No Role")
                //         (item == widget.items[0])
                //         ? Colors.blueGrey
                //         : Colors.black,
                //   ),
                // ),
                child: MyText(text: item),
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
