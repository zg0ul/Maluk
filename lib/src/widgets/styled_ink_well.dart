import 'package:flutter/material.dart';
import 'package:maluk/src/common/theme/style_constants.dart';

class StyledInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final bool enabled;

  const StyledInkWell({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      borderRadius: borderRadius ?? StyleConstants.cardBorderRadius,
      splashColor:
          enabled ? StyleConstants.getSplashColor(context) : Colors.transparent,
      highlightColor: StyleConstants.highlightColor,
      splashFactory: StyleConstants.splashFactory,
      child: child,
    );
  }
}
