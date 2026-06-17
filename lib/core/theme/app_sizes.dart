import 'package:flutter/material.dart';
import 'package:an_gi/core/utils/responsive_helper.dart'; // Đảm bảo đã import file này

class AppSizes {
  // Thay vì "get", ta chuyển thành hàm truyền context vào để co giãn động
  static double paddingXS(BuildContext context) => context.scaleW(4);
  static double paddingSM(BuildContext context) => context.scaleW(8);
  static double paddingMD(BuildContext context) => context.scaleW(16); // Lề tiêu chuẩn
  static double paddingLG(BuildContext context) => context.scaleW(24);
  static double paddingXL(BuildContext context) => context.scaleW(32);

  // Bo góc (Border Radius)
  static double radiusSM(BuildContext context) => context.scaleW(8);
  static double radiusMD(BuildContext context) => context.scaleW(12);
  static double radiusLG(BuildContext context) => context.scaleW(30);
  
  // Cỡ chữ chuẩn (Font Size)
  static double fontCaption(BuildContext context) => context.scaleSp(12);
  static double fontBody(BuildContext context) => context.scaleSp(16);
  static double fontSubTitle(BuildContext context) => context.scaleSp(18);
  static double fontTitle(BuildContext context) => context.scaleSp(24);
  static double fontHeader(BuildContext context) => context.scaleSp(28);
}