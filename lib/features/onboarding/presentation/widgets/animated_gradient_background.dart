// import 'package:flutter/material.dart';

// import '../../../../core/theme/app_colors.dart';

// class AnimatedGradientBackground extends StatefulWidget {
//   final Widget child;

//   const AnimatedGradientBackground({
//     super.key,
//     required this.child,
//   });

//   @override
//   State<AnimatedGradientBackground> createState() =>
//       _AnimatedGradientBackgroundState();
// }

// class _AnimatedGradientBackgroundState
//     extends State<AnimatedGradientBackground>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 15),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return AnimatedBuilder(
//   //     animation: _controller,
//   //     builder: (context, child) {
//   //       final animation = Curves.easeInOut.transform(
//   //         _controller.value,
//   //       );

//   //       return Container(
//   //         decoration: BoxDecoration(
//   //           gradient: RadialGradient(
//   //             center: Alignment(
//   //               -0.8 + animation * 1.6,
//   //               -0.8 + animation * 0.8,
//   //             ),
//   //             radius: 1.4,
//   //             colors: const [
//   //               AppColors.gradientPink,
//   //               AppColors.gradientPurple,
//   //               AppColors.bg,
//   //             ],
//   //             stops: [0.0, 0.35, 1.0],
//   //           ),
//   //         ),
//   //         child: child,
//   //       );
//   //     },
//   //     child: widget.child,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final value = Curves.easeInOut.transform(
//           _controller.value,
//         );

//         return Container(
//           color: AppColors.bg,
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               _GradientBlob(
//                 alignment: Alignment(
//                   -1.2 + value * 2.4,
//                   -1.0 + value * 0.5,
//                 ),
//                 size: 420,
//                 color: AppColors.gradientPink,
//               ),

//               _GradientBlob(
//                 alignment: Alignment(
//                   1.1 - value * 1.8,
//                   -0.2 + value * 1.2,
//                 ),
//                 size: 360,
//                 color: AppColors.gradientPurple,
//               ),

//               _GradientBlob(
//                 alignment: Alignment(
//                   0.3 - value * 0.8,
//                   1.2 - value * 0.5,
//                 ),
//                 size: 300,
//                 color: AppColors.gradientPinkDark,
//               ),

//               child!,
//             ],
//           ),
//         );
//       },
//       child: widget.child,
//     );
//   }
// }

// class _GradientBlob extends StatelessWidget {
//   final Alignment alignment;
//   final double size;
//   final Color color;

//   const _GradientBlob({
//     required this.alignment,
//     required this.size,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: alignment,
//       child: Container(
//         width: size,
//         height: size,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: RadialGradient(
//             colors: [
//               color.withValues(alpha: 0.65),
//               color.withValues(alpha: 0.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;

        return Container(
          color: AppColors.bg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _GradientBlob(
                x: _wave(
                  t,
                  offset: 0.0,
                  amplitude: 0.35,
                ),
                y: _wave(
                  t,
                  offset: 0.7,
                  amplitude: 0.18,
                ),
                size: 430,
                opacity: _pulse(t, offset: 0.0),
                color: AppColors.gradientPink,
              ),

              _GradientBlob(
                x: _wave(
                  t,
                  offset: 2.0,
                  amplitude: 0.28,
                ),
                y: _wave(
                  t,
                  offset: 1.3,
                  amplitude: 0.25,
                ),
                size: 380,
                opacity: _pulse(t, offset: 2.0),
                color: AppColors.gradientPurple,
              ),

              _GradientBlob(
                x: _wave(
                  t,
                  offset: 4.0,
                  amplitude: 0.25,
                ),
                y: _wave(
                  t,
                  offset: 3.0,
                  amplitude: 0.18,
                ),
                size: 340,
                opacity: _pulse(t, offset: 4.0),
                color: AppColors.gradientPinkDark,
              ),

              child!,
            ],
          ),
        );
      },
      child: widget.child,
    );
  }

  double _wave(
    double t, {
    required double offset,
    required double amplitude,
  }) {
    return math.sin(
      (t * 2 * math.pi) + offset,
    ) * amplitude;
  }

  double _pulse(
    double t, {
    required double offset,
  }) {
    return 0.45 +
        (math.sin(
              (t * 2 * math.pi) + offset,
            ) *
            0.12);
  }
}

class _GradientBlob extends StatelessWidget {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final Color color;

  const _GradientBlob({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(x, y),
      child: Transform.scale(
        scale: 1.0 + opacity * 0.15,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: opacity * 0.35),
                color.withValues(alpha: 0),
              ],
              stops: const [
                0.0,
                0.45,
                1.0,
              ],
            ),
          ),
        ),
      ),
    );
  }
}