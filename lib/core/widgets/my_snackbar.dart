import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos_system/core/utilities/dimension.dart';
import 'package:pos_system/core/widgets/progress_indicator_static.dart';

void showMyAnimatedSnackBar({
  required BuildContext context,
  required String dataToDisplay,
  Widget? widgetToDisplay,
  bool isUsingIcon = true,
  // Color borderColor = Colors.white,
  // Color bgColor = Colors.white60,
  // Color bgColor = const Color.fromARGB(242, 255, 255, 255),
  // Color bgColor = Colors.white70,
  Color? borderColor,
  Color? bgColor,
  bool isAutoDismiss = true,
  bool enabledBlurEffect = false,
  Icon? icon,
}) {
  final myColorScheme = Theme.of(context).colorScheme;

  final overlay = Overlay.of(context);

  final overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 20,
        left: 20,
        right: 20,
        child: TweenAnimationBuilder<Offset>(
          tween: Tween(begin: Offset.zero, end: const Offset(0, 1)),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, offset, child) {
            return Transform.translate(offset: offset * 80, child: child);
          },
          child: Material(
            color: Colors.transparent,
            // color: Colors.white70,
            child: BackdropFilter(
              enabled: enabledBlurEffect,
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgColor ?? myColorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: myColorScheme.inversePrimary),
                  boxShadow: [
                    BoxShadow(
                      color: myColorScheme.surfaceContainerHigh,
                      blurRadius: 4,
                      offset: Offset.zero,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (widgetToDisplay == null && isUsingIcon)
                      icon ??
                          Icon(
                            Icons.info_outline_rounded,
                            color: myColorScheme.outline,
                            size: 32,
                          ),
                    if (widgetToDisplay == null && isUsingIcon)
                      SizedBox(width: 8),
                    if (widgetToDisplay != null)
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MyDimensions.getWidth(context) * 0.15,
                          maxHeight: MyDimensions.getWidth(context) * 0.15,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: MyProgressIndicator(),
                        ),
                      ),
                    Expanded(child: Text(dataToDisplay, softWrap: true)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(overlayEntry);

  // Auto dismiss after 2s
  Future.delayed(const Duration(milliseconds: 3500), () {
    if (isAutoDismiss) {
      overlayEntry.remove();
    }
  });
}
