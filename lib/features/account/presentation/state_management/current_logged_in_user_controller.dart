// import 'package:pos_system/core/constants/app_collections.dart';
// import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
// import 'package:pos_system/features/account/presentation/state_management/personal_info_repo_provider.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'current_logged_in_user_controller.g.dart';

// @riverpod
// class CurrentLoggedInUserController extends _$CurrentLoggedInUserController {
//   @override
//   Future<PersonalInfo?> build() async {
//     // return null;
//     if (MyAppCollections.currentUserID == null) return null;

//     final repository = ref.watch(myPersonalInfoRepoProvider);
//     return repository.getByID(MyAppCollections.currentUserID!);
//   }

//   void setCurrentLoggedInUser(PersonalInfo? user) {
//     state = AsyncValue.data(user);
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pos_system/features/account/data/model/personal_info_model/personal_info.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_repo_provider.dart';
import 'package:pos_system/features/store/presentation/state_management/store_info_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_logged_in_user_controller.g.dart';

// 1. We create a simple provider to watch the Firebase Auth Stream
@riverpod
Stream<User?> firebaseAuthStream(FirebaseAuthStreamRef ref) {
  return FirebaseAuth.instance.authStateChanges();
}

// 2. Your Controller automatically reacts to the Auth Stream!
@riverpod
class CurrentLoggedInUserController extends _$CurrentLoggedInUserController {
  @override
  Future<PersonalInfo?> build() async {
    // Watch the auth stream. If it changes (login/logout), this whole build method re-runs!
    final authUser = ref.watch(firebaseAuthStreamProvider).value;

    // If there is no user logged into Firebase, return null immediately.
    if (authUser == null) return null;

    // If there is a user, fetch their data from Firestore.
    final repository = ref.watch(myPersonalInfoRepoProvider);
    return await repository.getByID(authUser.uid);
  }

  // Inside CurrentLoggedInUserController
  Future<void> changeCurrentStore(String newStoreId) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    // 1. Tell Firebase to update
    final repo = ref.read(myPersonalInfoRepoProvider);
    final updatedUser = currentUser.copyWith(currentStoreInView: newStoreId);
    await repo.update(updatedUser.id!, updatedUser);

    // 2. Update the local state
    state = AsyncValue.data(updatedUser);

    // 3. Tell the Store controller to change
    ref
        .read(storeInfoRepoControllerProvider.notifier)
        .setCurrentStore(newStoreId);
  }

  // Notice I DELETED the setCurrentLoggedInUser method!
  // You don't need it anymore. Riverpod handles the state automatically now.
}
