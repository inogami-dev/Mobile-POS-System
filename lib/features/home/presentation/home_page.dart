import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/presentation/widget/logged_in_user_account_store_details.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MyDimensions.getWidth(context);
    double height = MyDimensions.getHeight(context);

    // return Scaffold(
    //   backgroundColor: myColorScheme.surface,
    //   body: Center(child: const MyText(text: "Home Page")),
    // );

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  MyText(text: "Hello, ", fontSize: kDefaultFontSize + 4),
                  MyText(
                    text: "Name! ",
                    fontSize: kDefaultFontSize + 7,
                    fontWeight: FontWeight.w600,
                  ),
                  MyText(text: "Welcome back!", fontSize: kDefaultFontSize + 4),
                ],
              ),
              SizedBox(height: 20),

              LoggedInUserAccountStoreDetails(),
              SizedBox(height: 20),

              Column(
                children: [
                  MyText(text: "Most Sold Product/Item"),
                  MyText(text: "This week's trend"),
                  MyText(text: "Out of Stock Product/Item"),
                  MyText(text: "Staff icons"),
                  MyText(text: "Day, week, month revenue"),
                  MyText(text: "Day, week, month profit"),
                  MyText(text: "Products near expiration date"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
