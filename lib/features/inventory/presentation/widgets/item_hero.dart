import 'package:flutter/material.dart';
import 'package:pos_system/core/widgets/hero.dart';

class ItemHero extends StatelessWidget {
  final String heroTag;
  const ItemHero({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: MyHero(
          tag: heroTag,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Text(
                heroTag,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
