import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Utility class for consistent spacing across the app
class AppSpacer {
  // Height spacers
  static SizedBox get height4 => SizedBox(height: 4.h);
  static SizedBox get height8 => SizedBox(height: 8.h);
  static SizedBox get height12 => SizedBox(height: 12.h);
  static SizedBox get height16 => SizedBox(height: 16.h);
  static SizedBox get height20 => SizedBox(height: 20.h);
  static SizedBox get height24 => SizedBox(height: 24.h);
  static SizedBox get height32 => SizedBox(height: 32.h);
  static SizedBox get height40 => SizedBox(height: 40.h);
  static SizedBox get height48 => SizedBox(height: 48.h);

  // Width spacers
  static SizedBox get width4 => SizedBox(width: 4.w);
  static SizedBox get width8 => SizedBox(width: 8.w);
  static SizedBox get width12 => SizedBox(width: 12.w);
  static SizedBox get width16 => SizedBox(width: 16.w);
  static SizedBox get width20 => SizedBox(width: 20.w);
  static SizedBox get width24 => SizedBox(width: 24.w);
  static SizedBox get width32 => SizedBox(width: 32.w);
  static SizedBox get width40 => SizedBox(width: 40.w);
  static SizedBox get width48 => SizedBox(width: 48.w);

  // Custom spacers
  static SizedBox height(double height) => SizedBox(height: height.h);
  static SizedBox width(double width) => SizedBox(width: width.w);
}
