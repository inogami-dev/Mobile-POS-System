import 'package:pos_system/core/constants/app_collections.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/data/repository/personal_info_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_logged_in_user_controller.g.dart';

@riverpod
class CurrentLoggedInUserController extends _$CurrentLoggedInUserController {
  @override
  Future<PersonalInfo?> build() async {
    // return null;
    if (MyAppCollections.currentUserID == null) return null;

    final repository = ref.watch(myPersonalInfoRepoProvider);
    return repository.getByID(MyAppCollections.currentUserID!);
  }

  void setCurrentLoggedInUser(PersonalInfo user) {
    state = AsyncValue.data(user);
  }
}
