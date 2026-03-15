import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AppMoneyField extends StatelessWidget {
  const AppMoneyField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('\$', style: AppTypography.headlineXxl),
        SizedBox(width: AppSizes.sm),
        SizedBox(
          width: 100,
          child: FormBuilderTextField(
            name: 'amount',
          keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '50',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.md),
              ),
            ),
            style: AppTypography.headlineXxl,
          ),
        ),
      ],
    );
  }
}
