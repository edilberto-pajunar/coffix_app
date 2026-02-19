import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/images.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/features/auth/presentation/pages/create_account_page.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_field.dart';
import 'package:coffix_app/presentation/atoms/app_text_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  static String route = 'login_route';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onLogin() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // TODO: use _formKey.currentState!.value['email'] and ['password'] for login
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
                SvgPicture.asset(AppImages.nameLogo),
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
                  hintText: 'Enter your password',
                  obscureText: true,
                  showPasswordToggle: true,
                  isRequired: true,
                ),
                const SizedBox(height: AppSizes.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTextButton(
                    text: 'Forgot password?',
                    onPressed: () {},
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.accent,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(),
                      children: [
                        TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Create an account',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.accent,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.accent,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.goNamed(CreateAccountPage.route);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
                AppButton.primary(onPressed: _onLogin, label: 'Log in'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
