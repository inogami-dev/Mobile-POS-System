import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_system/features/account/presentation/state_management/personal_info_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final myColorScheme = Theme.of(context).colorScheme;

    // return Scaffold(
    //   backgroundColor: myColorScheme.surface,
    //   body: Center(child: const MyText(text: "Home Page")),
    // );

    /// Try ra ni
    var userState = ref.watch(personalInfoControllerProvider);
    return Scaffold(
      body: Center(
        child: userState.when(
          // data: (users) => Text("User count: ${users.length}"),
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          },
          loading: () => CircularProgressIndicator(),
          error: (err, stack) => Text("Error: $err"),
        ),
      ),
    );
  }
}
