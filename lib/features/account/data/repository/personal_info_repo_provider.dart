import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/features/account/data/repository/personal_info_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'personal_info_repo_provider.g.dart';

@riverpod
MyPersonalInfoRepository myPersonalInfoRepo(Ref ref) {
  // This tells Riverpod: "When someone asks for this provider,
  // create ONE instance of my repository and give it to them."
  return MyPersonalInfoRepository();
}
