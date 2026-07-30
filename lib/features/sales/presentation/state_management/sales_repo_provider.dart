import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/features/sales/data/repository/sales_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sales_repo_provider.g.dart';

@riverpod
SalesRepository salesRepo(Ref ref) {
  // This tells Riverpod: "When someone asks for this provider,
  // create ONE instance of my repository and give it to them."
  return SalesRepository();
}
