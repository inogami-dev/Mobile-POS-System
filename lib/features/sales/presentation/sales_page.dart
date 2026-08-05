import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/tab.dart';
import 'package:pos_system/core/widgets/tab_view.dart';

class MySalesPage extends StatefulWidget {
  const MySalesPage({super.key});

  @override
  State<MySalesPage> createState() => _MySalesPageState();
}

class _MySalesPageState extends State<MySalesPage> {
  @override
  Widget build(BuildContext context) {
    final width = MyDimensions.getWidth(context);
    final height = MyDimensions.getHeight(context);
    // final myColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: MyText(text: "Sales", fontSize: 24, fontWeight: FontWeight.w600),
      //   leading: InkWell(
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: Container(
      //       // color: Colors.amber,
      //       padding: const EdgeInsets.only(
      //         left: 8,
      //         top: 8,
      //         bottom: 8,
      //         right: 0,
      //       ),
      //       child: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
      //     ),
      //   ),
      //   leadingWidth: 45,
      // ),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          // color: Colors.blueAccent,
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Container(
          //       width: width * 0.8,
          //       height: height * 0.3,
          //       color: Colors.amber,
          //     ),
          child: MyTabView(
            children: [
              Container(
                width: width * 0.8,
                height: height * 0.3,
                color: Colors.amber,
              ),
              Container(
                width: width * 0.8,
                height: height * 0.3,
                color: Colors.orange,
              ),
              Container(
                width: width * 0.8,
                height: height * 0.3,
                color: Colors.green,
              ),
            ],
            childrenTabIcons: [
              MyTab(
                text: "Most/Least Sold",
                icon: HugeIcon(icon: HugeIcons.strokeRoundedPieChart),
              ),
              MyTab(
                text: "Weekly Trend",
                icon: HugeIcon(icon: HugeIcons.strokeRoundedChartIncrease),
              ),
              MyTab(
                text: "Profit/Loss",
                icon: HugeIcon(icon: HugeIcons.strokeRoundedChartGantt),
              ),
            ],
          ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
