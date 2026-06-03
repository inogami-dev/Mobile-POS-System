import 'package:pos_system/features/account/data/repository/personal_info_repo_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';

part 'all_users_controller.g.dart';

@riverpod
class AllUsersController extends _$AllUsersController {
  @override
  // Riverpod knows this is an AsyncNotifier because it returns a Future!
  Future<List<PersonalInfo>> build() async {
    // 1. DEPENDENCY INJECTION: Grab the repository using ref.watch
    final repository = ref.watch(myPersonalInfoRepoProvider);

    // 2. INITIAL FETCH: Riverpod will automatically await this
    // and show a loading state on your UI until it finishes.
    return repository.getAllPersonalInfo();
  }

  // -------------------------------------------------------------
  // ACTION: Only needed if you want to force a manual refresh
  // (like pulling down to refresh a list).
  // -------------------------------------------------------------
  Future<void> refreshUsers() async {
    // Manually set the state to loading
    state = const AsyncValue.loading();

    // Grab the repo (use read for actions, not watch)
    final repository = ref.read(myPersonalInfoRepoProvider);

    // AsyncValue.guard automatically handles try/catch and updates the state!
    // If it succeeds, state becomes AsyncData. If it fails, state becomes AsyncError.
    state = await AsyncValue.guard(() async {
      return repository.getAllPersonalInfo();
    });
  }
}
