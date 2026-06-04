// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pos_system/core/utilities/error_logger.dart';
// import 'package:pos_system/core/widgets/no_role_page.dart';
// import 'package:pos_system/core/widgets/progress_indicator_static.dart';
// import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_with_navbar.dart';
// import 'package:pos_system/core/widgets/text_formatter.dart';
// import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
// import 'package:pos_system/features/account/presentation/state_management/personal_info_repo_provider.dart';
// import 'package:pos_system/features/authentication/presentation/login_page.dart';

// class LoggedInStream extends ConsumerStatefulWidget {
//   const LoggedInStream({super.key});

//   @override
//   _LoggedInStreamState createState() => _LoggedInStreamState();
// }

// class _LoggedInStreamState extends ConsumerState<LoggedInStream> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final myPersonalInfoRepoRef = ref.read(myPersonalInfoRepoProvider);
//     // final currentLoggedInUserState = ref.watch(
//     //   currentLoggedInUserControllerProvider,
//     // );
//     // CurrentLoggedInUserController c = CurrentLoggedInUserController();

//     return StreamBuilder(
//       // this it the StreamBuilder's source of data, a Stream with generic User type
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, streamSnapshot) {
//         // if the stream is just ongoing yet, a loading visual will appear temporarily
//         if (streamSnapshot.connectionState == ConnectionState.waiting) {
//           // we need to have a temporary scaffold here to have a surface for the loading visual
//           return Scaffold(
//             body: const Center(child: const MyProgressIndicator()),
//           );
//         } else if (streamSnapshot.data != null) {
//           // a FutureBuilder is just like a StreamBuilder but it is done after the execution of the Future is finished.
//           return FutureBuilder(
//             // FutureBuilder's source of data, a Future with generic PersonalInfo type
//             // future: MyPersonalInfoRepository.getSpecificPersonalInfo(
//             //   userID: streamSnapshot.data!.uid,
//             // ),
//             future: myPersonalInfoRepoRef.getByID(streamSnapshot.data!.uid),
//             builder: (context, futureSnapshot) {
//               log(
//                 "Logged in User's Name: ${futureSnapshot.data?.name}",
//               ); // futureSnapshot.data?.customerAt.isEmpty;

//               // returns a loading visual if the future is still ongoing
//               if (futureSnapshot.connectionState == ConnectionState.waiting) {
//                 // we need to have a temporary scaffold here to have a surface for the loading visual
//                 return Scaffold(
//                   body: SafeArea(
//                     child: const Center(child: const MyProgressIndicator()),
//                   ),
//                 );
//               } else if (!futureSnapshot.hasData) {
//                 return Scaffold(
//                   body: SafeArea(
//                     child: const Center(
//                       child: MyText(text: "No data found for the user."),
//                     ),
//                   ),
//                 );
//               }
//               //
//               else if (isNotRegisteredToAStore(futureSnapshot)) {
//                 return NoRoleYetLandingPage(
//                   userNameToDisplay: futureSnapshot.data!.name,
//                 );
//               }
//               // // will direct you to the HomePage if the user has a data and has a role
//               else {
//                 ref.invalidate(currentLoggedInUserControllerProvider);

//                 return MyRootScaffoldWithNavBar();
//               }
//             },
//           );
//         }
//         // will direct you to the LoginPage if the user has no data, meaning the user is not logged in or not yet registered
//         else {
//           return LoginPage();
//         }
//       },
//     );
//   }

//   bool isNotRegisteredToAStore(AsyncSnapshot snapshot) {
//     if (snapshot.hasData) {
//       bool isNotRegisteredToAStore =
//           (snapshot.data!.ownerAt.isEmpty) && (snapshot.data!.staffAt.isEmpty);
//       MyLogger.success(
//         successLabel: "isNotRegisteredToAStore: ",
//         successMessage: isNotRegisteredToAStore.toString(),
//       );
//       return isNotRegisteredToAStore;
//     } else {
//       return false;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/no_role_page.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_with_navbar.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/authentication/presentation/login_page.dart';
// ... your other imports ...

class LoggedInStream extends ConsumerWidget {
  const LoggedInStream({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the Riverpod Controller we just made
    final userState = ref.watch(currentLoggedInUserControllerProvider);

    // 2. Use Riverpod's built-in .when() to handle Loading, Error, and Data
    return userState.when(
      loading: () => const Scaffold(body: Center(child: MyProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text("Error: $error"))),
      data: (personalInfo) {
        // 3. Routing Logic

        // Scenario A: No user is logged in (Data is null)
        if (personalInfo == null) {
          return const LoginPage();
        }

        // Scenario B: User is logged in, but has no role yet
        if (personalInfo.ownerAt.isEmpty && personalInfo.staffAt.isEmpty) {
          return NoRoleYetLandingPage(userNameToDisplay: personalInfo.name);
        }

        // Scenario C: User is fully logged in and has a role
        return const MyRootScaffoldWithNavBar();
      },
    );
  }
}
