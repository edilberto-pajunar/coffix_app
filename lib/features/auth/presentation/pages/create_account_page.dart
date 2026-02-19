import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/auth/presentation/pages/login_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_field.dart';
import 'package:coffix_app/presentation/atoms/app_icon_button.dart';
import 'package:coffix_app/presentation/atoms/app_text_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class CreateAccountPage extends StatelessWidget {
  static String route = 'create_account_route';
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreateAccountView();
  }
}

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onNext() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // TODO: use _formKey.currentState!.value['email'] and ['password'] for create account
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSizes.defaultPadding,
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSizes.xxl),
                AppField<String>(
                  name: 'email',
                  label: 'Email',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  isRequired: true,
                  validators: [FormBuilderValidators.email()],
                ),
                const SizedBox(height: AppSizes.lg),
                AppField<String>(
                  name: 'password',
                  label: 'Password',
                  hintText: 'Create a password',
                  obscureText: true,
                  showPasswordToggle: true,
                  isRequired: true,
                ),

                const SizedBox(height: AppSizes.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(),
                      children: [
                        TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: 'Login',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.accent,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.accent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.goNamed(LoginPage.route);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.borderColor,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                      ),
                      child: Text("or continue with"),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.borderColor,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.xxxxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppIconButton.withSvgPath(
                      AppImages.google,
                      onPressed: () {},
                    ),
                    AppIconButton.withSvgPath(
                      AppImages.facebook,
                      onPressed: () {},
                    ),
                    AppIconButton.withSvgPath(
                      AppImages.apple,
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.lg),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(),
                    children: [
                      TextSpan(text: "By registering you accept our "),
                      TextSpan(
                        text: 'Terms of Use & Privacy',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.xxxxl),
                AppButton.primary(onPressed: _onNext, label: 'Next'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
