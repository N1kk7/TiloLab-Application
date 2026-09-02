import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum TooltipType { error, warning, success }

extension TooltipTypeStyle on TooltipType {
  IconData get icon {
    switch (this) {
      case TooltipType.error:
        return Icons.error_outline;
      case TooltipType.warning:
        return Icons.warning_amber_rounded;
      case TooltipType.success:
        return Icons.check_circle_outline;
    }
  }

  Color get background {
    switch (this) {
      case TooltipType.error:
        return AppColors.errorBg;
      case TooltipType.warning:
        return AppColors.warningBg;
      case TooltipType.success:
        return AppColors.successBg;
    }
  }

  Color get border {
    switch (this) {
      case TooltipType.error:
        return AppColors.errorBorder;
      case TooltipType.warning:
        return AppColors.warningBorder;
      case TooltipType.success:
        return AppColors.successBorder;
    }
  }

  Color get text {
    switch (this) {
      case TooltipType.error:
        return AppColors.errorText;
      case TooltipType.warning:
        return AppColors.warningText;
      case TooltipType.success:
        return AppColors.successText;
    }
  }
}