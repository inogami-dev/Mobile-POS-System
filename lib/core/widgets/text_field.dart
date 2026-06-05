import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/authentication/presentation/widgets/eyecon.dart';

class MyTextfield extends StatefulWidget {
  /// The width is automatically adjusted base on the screensize, so the widthPercentage is the ratio of how much of the screen you want to occupy.
  final double widthPercentage;

  /// The height is automatically adjusted base on the screensize, so the heightPercentage is the ratio of how much of the screen you want to occupy.
  final double heightPercentage;

  final bool isUsingStaticDimension;
  final String? hintText;
  final String labelText;
  // final IconData prefixIcon;
  final HugeIcon prefixIcon;
  final Color? prefixIconColor;
  final double borderRadius;
  final double borderWidth;
  final double focusBorderWidth;
  final Color? borderColor;
  final Color? activeBorderColor;
  final FocusNode? focusNode;
  final bool isPasswordField;
  // final Color color;
  // final IconData? suffixIcon;
  final HugeIcon? suffixIcon;
  final Color? suffixIconColor;
  final bool isReadOnly;
  final double leftMargin;
  final double topMargin;
  final double rightMargin;
  final double bottomMargin;
  final TextInputType? textInputType;

  /// This will manage the data the textfield will accept
  final TextEditingController textController;

  /// My customized textfield
  const MyTextfield({
    super.key,
    this.isUsingStaticDimension = true,
    this.widthPercentage = 1.0,
    this.heightPercentage = 1.0,
    this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    required this.textController,
    this.borderRadius = 30,
    this.borderWidth = 1,
    this.focusBorderWidth = 1.5,
    this.borderColor,
    this.activeBorderColor,
    this.focusNode,
    this.isPasswordField = false,
    // this.color = Colors.transparent,
    this.suffixIcon,
    this.isReadOnly = false,
    this.leftMargin = 0,
    this.topMargin = 0,
    this.rightMargin = 0,
    this.bottomMargin = 0,
    this.textInputType,
  });

  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  bool _isObscurePassword = false;

  @override
  void initState() {
    super.initState();

    if (widget.isPasswordField) {
      _isObscurePassword = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme myColorScheme = Theme.of(context).colorScheme;
    Color prefixIconColor =
        widget.prefixIconColor ?? myColorScheme.onSurfaceVariant;
    Color suffixIconColor =
        widget.suffixIconColor ?? myColorScheme.onSurfaceVariant;
    Color borderColor = widget.borderColor ?? myColorScheme.primaryFixed;
    // Color borderColor = Colors.amber;
    Color activeBorderColor =
        widget.activeBorderColor ?? myColorScheme.primaryFixed;

    return Container(
      // color: Colors.amber,
      width: (widget.isUsingStaticDimension)
          ? MyDimensions.getWidth(context) * 0.80
          : MyDimensions.getWidth(context) * widget.widthPercentage,
      height: (widget.isUsingStaticDimension)
          ? 50
          : MyDimensions.getHeight(context) * widget.heightPercentage,
      margin: EdgeInsets.only(
        left: widget.leftMargin,
        top: widget.topMargin,
        right: widget.rightMargin,
        bottom: widget.bottomMargin,
      ),
      // color: Colors.purple.shade200,
      child: TextField(
        // inputFormatters: TextInputType.numberWithOptions(),
        keyboardType: widget.textInputType,
        controller: widget.textController,
        focusNode: widget.focusNode,
        readOnly: widget.isReadOnly,
        obscureText: _isObscurePassword,
        obscuringCharacter: "*",
        cursorColor: myColorScheme.outline,
        decoration: InputDecoration(
          // labelText: widget.labelText,
          label: MyText(text: widget.labelText, color: myColorScheme.onSurface),
          //   widget.labelText,
          //   style: TextStyle(color: myColorScheme.onSurface),
          // ),
          // hint text, example: inogami@gmail.com
          hint: (widget.hintText != null)
              ? Text(
                  widget.hintText!,
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                )
              : Text(""),
          alignLabelWithHint: true,
          filled: true,
          contentPadding: const EdgeInsets.only(top: 3, right: 3, bottom: 5),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            // child: Icon(widget.prefixIcon),
            child: widget.prefixIcon,
          ),
          prefixIconConstraints: BoxConstraints.tight(Size(50, 32)),
          prefixIconColor: prefixIconColor,
          suffixIcon: (widget.suffixIcon != null || widget.isPasswordField)
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscurePassword = !_isObscurePassword;
                    });
                  },
                  child: (widget.isPasswordField)
                      ? EyeCon(
                          isPasswordVisible: _isObscurePassword,
                          color: suffixIconColor,
                        )
                      // : Icon(
                      //     widget.suffixIcon,
                      //     color: suffixIconColor,
                      //     blendMode: BlendMode.src,
                      //   ),
                      : widget.suffixIcon!,
                )
              : null,
          suffixIconColor: suffixIconColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: borderColor,
              width: widget.borderWidth,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: activeBorderColor,
              width: widget.borderWidth + widget.focusBorderWidth,
            ),
          ),
        ),
      ),
    );
  }
}
