// import 'dart:ui';
// import 'package:flutter/material.dart';

// class MyFrostedContainer extends StatelessWidget {
//   final double? width;
//   final double? height;
//   final Color? color;
//   final double? borderRadius;
//   final BorderRadius? customBorderRadius;
//   final Border? border;
//   final Color? borderColor;
//   final bool enableShadow;
//   final Widget? child;

//   const MyFrostedContainer({
//     super.key,
//     this.width,
//     this.height,
//     this.color,
//     this.borderRadius,
//     this.customBorderRadius,
//     this.border,
//     this.borderColor,
//     this.enableShadow = true,
//     this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Default to a 16px radius if none is provided
//     final effectiveBorderRadius =
//         customBorderRadius ?? BorderRadius.circular(borderRadius ?? 16.0);

//     return Center(
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           borderRadius: effectiveBorderRadius,
//           // 1. THE EDGE HIGHLIGHT: Simulates light hitting the rim of the glass
//           border:
//               border ??
//               Border.all(
//                 color: borderColor ?? Colors.white.withOpacity(0.2),
//                 width: 1.0,
//               ),
//           // 2. THE DROP SHADOW: Gives depth so the glass floats above the background
//           boxShadow: enableShadow
//               ? [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     spreadRadius: 1,
//                   ),
//                 ]
//               : null,
//         ),

//         // The Cookie Cutter
//         child: ClipRRect(
//           borderRadius: effectiveBorderRadius,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // 3. THE HEAVY BLUR: A much higher sigma creates that true frosted dispersion
//               BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
//                 child: const SizedBox(),
//               ),

//               // 4. THE GLASS TINT: A very sheer white overlay (or custom color)
//               Container(
//                 decoration: BoxDecoration(
//                   color: color ?? Colors.white.withOpacity(0.15),
//                   // Optional: You can replace 'color' with a subtle gradient for extra realism
//                   /* gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [
//                       Colors.white.withOpacity(0.25),
//                       Colors.white.withOpacity(0.05),
//                     ],
//                   ),
//                   */
//                 ),
//               ),

//               // 5. THE CONTENT
//               if (child != null) child!,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
