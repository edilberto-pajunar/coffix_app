import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PersonalInfoPage extends StatelessWidget {
  static String route = 'personal_info_route';
  const PersonalInfoPage({super.key, this.initialEmail});

  final String? initialEmail;

  @override
  Widget build(BuildContext context) {
    return PersonalInfoView(email: initialEmail ?? '');
  }
}

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key, required this.email});

  final String email;

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSave() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // TODO: save personal info from _formKey.currentState!.value
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal info', style: theme.textTheme.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSizes.defaultPadding,
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppField<String>(
                name: 'email',
                label: 'Email',
                hintText: 'Email',
                initialValue: widget.email,
                readOnly: true,
              ),
              const SizedBox(height: AppSizes.lg),
              AppField<String>(
                name: 'firstName',
                label: 'First name',
                hintText: 'Enter first name',
                isRequired: true,
              ),
              const SizedBox(height: AppSizes.lg),
              AppField<String>(
                name: 'lastName',
                label: 'Last name',
                hintText: 'Enter last name',
                isRequired: true,
              ),
              const SizedBox(height: AppSizes.lg),
              AppField<String>(
                name: 'nickname',
                label: 'Nickname',
                hintText: 'Enter nickname',
              ),
              const SizedBox(height: AppSizes.lg),
              AppField<String>(
                name: 'mobile',
                label: 'Mobile',
                hintText: 'Enter mobile',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSizes.lg),
              FormBuilderDateTimePicker(
                name: 'birthday',
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  hintText: 'Select date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.md),
                    borderSide: BorderSide(color: AppColors.borderColor),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              AppField<String>(
                name: 'suburb',
                label: 'Suburb',
                hintText: 'Enter suburb',
              ),
              const SizedBox(height: AppSizes.lg),
              AppField<String>(
                name: 'city',
                label: 'City',
                hintText: 'Enter city',
              ),
              const SizedBox(height: AppSizes.lg),
              AppField<String>(
                name: 'preferredStore',
                label: 'Preferred store',
                hintText: 'Enter preferred store',
              ),
              const SizedBox(height: AppSizes.xxl),
              Text('Settings', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSizes.sm),
              FormBuilderSwitch(
                name: 'receiveNotification',
                title: Text(
                  'Receive notification',
                  style: theme.textTheme.bodyMedium,
                ),
                initialValue: true,
              ),
              FormBuilderSwitch(
                name: 'receiveNewsAndPromotions',
                title: Text(
                  'Receive news and promotions',
                  style: theme.textTheme.bodyMedium,
                ),
                initialValue: true,
              ),
              FormBuilderSwitch(
                name: 'receivePurchaseMessages',
                title: Text(
                  'Receive purchase messages',
                  style: theme.textTheme.bodyMedium,
                ),
                initialValue: true,
              ),
              const SizedBox(height: AppSizes.xxl),
              AppButton.primary(onPressed: _onSave, label: 'Save'),
              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
