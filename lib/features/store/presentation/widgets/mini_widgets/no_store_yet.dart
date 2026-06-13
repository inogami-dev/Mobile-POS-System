import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/bottom_sheet.dart';
import 'package:pos_system/core/widgets/button.dart';
import 'package:pos_system/core/widgets/container.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/store/presentation/widgets/register_store_form.dart';

class NoStoreYet extends ConsumerWidget {
  const NoStoreYet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myColorScheme = Theme.of(context).colorScheme;

    return MyContainer(
      width: MyDimensions.getWidth(context) * 0.8,
      padding: EdgeInsets.all(16),
      child: Column(
        spacing: 20,
        children: [
          MyText(text: "It seems you dont have any stores yet."),
          MyButton(
            buttonText: "Register A Store",
            color: myColorScheme.surfaceContainer,
            widthPercentage: 0.56,
            borderColor: myColorScheme.primary,
            onTap: () {
              showMyBottomSheet(context: context, child: RegisterStoreForm());
            },
          ),
          // const MyEmptyUI(),
        ],
      ),
    );
  }
}
