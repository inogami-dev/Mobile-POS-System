import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_field.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';

class RegisterStoreForm extends StatefulWidget {
  const RegisterStoreForm({super.key});

  @override
  State<RegisterStoreForm> createState() => _RegisterStoreFormState();
}

class _RegisterStoreFormState extends State<RegisterStoreForm> {
  late double width;
  late double height;

  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeOwnerController = TextEditingController();
  TextEditingController pictureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    width = MyDimensions.getWidth(context);
    height = MyDimensions.getHeight(context);
    final myColorScheme = Theme.of(context).colorScheme;

    return MyContainer(
      width: width,
      height: height * 0.56,
      // color: myColorScheme.surface,
      child: Column(
        children: [
          MyText(text: "Register Store Form"),
          MyTextfield(
            labelText: "Store Name",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedStore01),
            textController: storeNameController,
          ),
          MyTextfield(
            labelText: "Store Owner",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedUser02),
            textController: storeOwnerController,
          ),
          MyTextfield(
            labelText: "Picture",
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedImage01),
            textController: pictureController,
          ),
        ],
      ),
    );
  }
}
