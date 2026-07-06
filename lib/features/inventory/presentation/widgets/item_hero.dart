import 'package:flutter/material.dart';

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
        child: Hero(
          tag: heroTag,
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Text(
                "Item Hero",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
