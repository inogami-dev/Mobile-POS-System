import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/core/widgets/no_role_page.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';
import 'package:pos_system/core/widgets/root_scaffold/root_scaffold_with_navbar.dart';
import 'package:pos_system/core/widgets/text_formatter.dart';
import 'package:pos_system/features/account/presentation/state_management/current_logged_in_user_controller.dart';
import 'package:pos_system/features/authentication/presentation/login_page.dart';

class LoggedInStream extends ConsumerWidget {
  const LoggedInStream({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the Riverpod Controller we just made
    final userState = ref.watch(currentLoggedInUserControllerProvider);

    // 2. Use Riverpod's built-in .when() to handle Loading, Error, and Data
    return userState.when(
      loading: () => const Scaffold(body: Center(child: MyProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          // child: MyText(text: "Error: $error, \nStack: $stack", maxLines: 20),
          child: MyText(text: "Oops! Please check your internet connection."),
        ),
      ),
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
