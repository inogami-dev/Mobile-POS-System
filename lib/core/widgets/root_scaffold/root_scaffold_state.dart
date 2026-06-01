import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_scaffold_state.g.dart';

@riverpod
class RootScaffoldState extends _$RootScaffoldState {
  @override
  int build() {
    ref.keepAlive(); // prevent auto-disposal when not in use
    return 0;
  }

  void changeIndex(int index) {
    state = index;
  }
}
