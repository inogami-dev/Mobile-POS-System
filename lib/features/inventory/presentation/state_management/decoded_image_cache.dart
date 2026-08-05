import 'dart:typed_data';

import 'package:pos_system/core/utilities/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'decoded_image_cache.g.dart';

/// For you future self:
/// This caching method is necessary to avoid decoding the same image multiple
/// times. Causing the image to blink when scrolling through the list of products.
/// This is because the image is being decoded every time the widget is rebuilt.
/// By caching the decoded image, we can avoid this issue.
@Riverpod(keepAlive: true)
class MyDecodedImageCache extends _$MyDecodedImageCache {
  @override
  Map<String, Uint8List> build() {
    return {};
  }

  void addImageToDecode(String originalImage) {
    // state = {...state, imagePath: decodedImagePath};
    final Uint8List decodedImage = MyImageProcessor.decodeStringToUint8List(
      originalImage,
    );
    final tempState = {...state};
    tempState[originalImage] = decodedImage;
    state = tempState;
  }

  Uint8List? getDecodedImage(String imagePath) {
    return state[imagePath];
  }

  void removeDecodedImage(String imagePath) {
    // state = {...state}..remove(imagePath);
    final tempState = {...state};
    tempState.remove(imagePath);
    state = tempState;
  }
}
