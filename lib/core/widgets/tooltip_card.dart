import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'package:tilolab_app/core/services/tooltip_type.dart';

class TooltipCard extends StatefulWidget {
  final TooltipType type;
  final String message;
  final Duration displayDuration;
  final VoidCallback onDismissed;

  const TooltipCard({
    super.key,
    required this.type,
    required this.message,
    required this.displayDuration,
    required this.onDismissed,
  });

  @override
  State<TooltipCard> createState() => _TooltipCardState();
}

class _TooltipCardState extends State<TooltipCard> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    reverseDuration: const Duration(milliseconds: 220),
  );

  late final Animation<Offset> slide = Tween(
    begin: const Offset(0, -1.2),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack, reverseCurve: Curves.easeIn));

  late final Animation<double> fade = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _play();
  }

  Future<void> _play() async {
    await controller.forward();
    await Future.delayed(widget.displayDuration);
    if (!mounted) return;
    await controller.reverse();
    if (!mounted) return;
    widget.onDismissed();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: fade,
        child: GestureDetector(
          onTap: () async {
            await controller.reverse();
            if (mounted) widget.onDismissed();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: widget.type.background.withOpacity(0.82),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: widget.type.border.withOpacity(0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.type.icon, size: 20, color: widget.type.border),
                    const SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: widget.type.text,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}