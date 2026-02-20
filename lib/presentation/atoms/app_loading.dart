import 'package:coffix_app/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPulsingGrid(color: AppColors.primary, size: 24),
    );
  }
}
