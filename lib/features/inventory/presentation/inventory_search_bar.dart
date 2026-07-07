import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/searchbar.dart';

class MyInventorySearchBar extends ConsumerStatefulWidget {
  const MyInventorySearchBar({super.key});

  @override
  ConsumerState<MyInventorySearchBar> createState() =>
      _MyInventorySearchBarState();
}

class _MyInventorySearchBarState extends ConsumerState<MyInventorySearchBar> {
  @override
  Widget build(BuildContext context) {
    return MySearchBar();
  }
}
