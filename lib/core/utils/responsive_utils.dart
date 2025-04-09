// responsive_utils.dart
import 'package:flutter/material.dart';

class ResponsiveUtils {
  final BuildContext context;
  final Size _screenSize;
  
  ResponsiveUtils(this.context) : _screenSize = MediaQuery.of(context).size;
  
  bool get isMobile => _screenSize.width < 600;
  bool get isTablet => _screenSize.width >= 600 && _screenSize.width < 1200;
  bool get isDesktop => _screenSize.width >= 1200;
  
  double get width => _screenSize.width;
  double get height => _screenSize.height;
  
  EdgeInsets get defaultPadding => EdgeInsets.all(isMobile ? 12.0 : 16.0);
  
  double responsiveValue({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }

  
  double responsiveFontSize({
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile) return mobile * 0.8;
    if (isTablet) return tablet * 0.9;
    return desktop;
  }
  
  Widget responsiveWidget({
    required Widget mobile,
    required Widget tablet,
    required Widget desktop,
  }) {
    if (isMobile) return mobile;
    if (isTablet) return tablet;
    return desktop;
  }
}