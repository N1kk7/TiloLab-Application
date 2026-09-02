import 'package:flutter/material.dart';

import 'package:tilolab_app/core/widgets/tooltip_card.dart';
import 'package:tilolab_app/core/services/tooltip_type.dart';

import 'package:tilolab_app/core/theme/app_spacing.dart';

class AppToast {
  AppToast._();

  static final List<OverlayEntry> _activeEntries = [];
  static const double _toastHeight = 56;
  static const double _toastGap = AppToast._gap;
  static const double _gap = 8;

  static void show(
  BuildContext context, {
  required TooltipType type,
  required String message,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlayState = Overlay.of(context, rootOverlay: true);

  final topInset = MediaQuery.of(overlayState.context).padding.top;

  final stackOffset = _activeEntries.length * (_toastHeight + _toastGap);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => Positioned(
      top: topInset + AppSpacing.sm + stackOffset,
      left: AppSpacing.lg,
      right: AppSpacing.lg,
      child: Material(
        color: Colors.transparent,
        child: TooltipCard(
          type: type,
          message: message,
          displayDuration: duration,
          onDismissed: () {
            entry.remove();
            _activeEntries.remove(entry);
          },
        ),
      ),
    ),
  );

  _activeEntries.add(entry);
  overlayState.insert(entry);
}

  static void error(BuildContext context, String message) =>
      show(context, type: TooltipType.error, message: message);

  static void warning(BuildContext context, String message) =>
      show(context, type: TooltipType.warning, message: message);

  static void success(BuildContext context, String message) =>
      show(context, type: TooltipType.success, message: message);
}

class AppSpacingLocal {
  static const md = 16.0;
  static const lg = 24.0;
}