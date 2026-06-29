import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'picked_image_value.g.dart';

@riverpod
class PickedImageValue extends _$PickedImageValue {
  @override
  String build() => "";

  void setPickedImage(String image) {
    state = image;
  }

  void removeCachedImage() {
    state = "";
  }
}
