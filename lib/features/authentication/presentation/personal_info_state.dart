import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/repository/personal_info_repository.dart';

final personalInforRepoProvider = Provider<MyPersonalInfoRepository>((ref) {
  return MyPersonalInfoRepository();
});
