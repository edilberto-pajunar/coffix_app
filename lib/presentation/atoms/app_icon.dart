import 'package:coffix_app/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A reusable icon atom widget.
///
/// Displays either an IconData icon or an SVG asset.
/// No padding or margins - parent controls spacing.
///
/// Usage:
/// ```dart
/// // With IconData
/// AppIcon.withIconData(
///   Icons.search,
///   size: AppSizes.iconSizeMedium,
///   color: AppColors.primary,
/// )
///
/// // With SVG path
/// AppIcon.withSvgPath(
///   AppIcons.check,
///   size: AppSizes.iconSizeSmall,
///   color: AppColors.primary,
/// )
/// ```
class AppIcon extends StatelessWidget {
  /// The icon data (for Material icons).
  final IconData? _iconData;

  /// The SVG asset path.
  final String? _svgPath;

  /// The size of the icon. Defaults to AppSizes.iconSizeMedium if not provided.
  final double? size;

  /// The color of the icon. If null, inherits from theme.
  final Color? color;

  /// Creates an AppIcon from IconData.
  const AppIcon.withIconData(IconData icon, {super.key, this.size, this.color})
    : _iconData = icon,
      _svgPath = null;

  /// Creates an AppIcon from an SVG asset path.
  const AppIcon.withSvgPath(String svgPath, {super.key, this.size, this.color})
    : _iconData = null,
      _svgPath = svgPath;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? AppSizes.iconSizeMedium;

    final iconData = _iconData;
    if (iconData != null) {
      return Icon(iconData, size: iconSize, color: color);
    }

    final svgPath = _svgPath;
    if (svgPath != null) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: SvgPicture.asset(
          svgPath,
          width: iconSize,
          height: iconSize,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
        ),
      );
    }

    // This should never happen due to constructor constraints,
    // but provide a fallback for safety
    return const SizedBox.shrink();
  }
}
