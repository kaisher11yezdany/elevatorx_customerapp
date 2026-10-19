import 'package:flutter/material.dart';
import '../config/constants.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final bool outlined;
  final Widget? prefixIcon;

  const AppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.outlined = false,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: outlined ? Colors.transparent : (backgroundColor ?? AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: outlined
            ? const BorderSide(color: AppColors.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        child: Container(
          height: height ?? 48,
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: AppTextStyles.button.copyWith(
                        color: outlined ? AppColors.primary : (textColor ?? Colors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}
