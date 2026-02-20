import 'package:coffix_app/core/constants/colors.dart';
import 'package:coffix_app/core/constants/sizes.dart';
import 'package:coffix_app/core/di/service_locator.dart';
import 'package:coffix_app/features/auth/data/model/user.dart';
import 'package:coffix_app/features/auth/logic/auth_cubit.dart';
import 'package:coffix_app/features/home/presentation/pages/home_page.dart';
import 'package:coffix_app/features/profile/logic/profile_cubit.dart';
import 'package:coffix_app/presentation/atoms/app_button.dart';
import 'package:coffix_app/presentation/atoms/app_field.dart';
import 'package:coffix_app/presentation/atoms/app_loading.dart';
import 'package:coffix_app/presentation/atoms/app_snackbar.dart';
import 'package:coffix_app/presentation/organisms/app_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PersonalInfoPage extends StatelessWidget {
  static String route = 'personal_info_route';
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ProfileCubit>(),
      child: PersonalInfoView(),
    );
  }
}

class PersonalInfoView extends StatefulWidget {
  const PersonalInfoView({super.key});

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSave() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formValues = _formKey.currentState?.value;
      context.read<ProfileCubit>().updateProfile(
        firstName: formValues?['firstName'],
        lastName: formValues?['lastName'],
        nickName: formValues?['nickname'],
        mobile: formValues?['mobile'],
        // birthday: formValues?['birthDate'],
        suburb: formValues?['suburb'],
        city: formValues?['city'],
        preferredStore: formValues?['preferredStore'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AppUser? user = context.watch<AuthCubit>().state.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );

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
          initialValue: {
            'email': user?.email,
            "firstName": user?.firstName,
            "lastName": user?.lastName,
            "nickname": user?.nickName,
            "mobile": user?.mobile,
            "birthday": user?.birthday,
            "suburb": user?.suburb,
            "city": user?.city,
            "preferredStore": user?.preferredStore,
          },
          key: _formKey,
          child: BlocConsumer<ProfileCubit, ProfileState>(
            listener: (context, state) {
              state.mapOrNull(
                success: (state) {
                  AppSnackbar.showSuccess(
                    context,
                    "Profile updated successfully",
                  );
                  context.goNamed(HomePage.route);
                },
                error: (state) =>
                    AppError(title: "Error", subtitle: state.message),
              );
            },
            builder: (context, state) {
              state.mapOrNull(loading: (state) => AppLoading());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppField<String>(
                    name: 'email',
                    label: 'Email',
                    hintText: 'Email',
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
                    isRequired: true,
                  ),
                  const SizedBox(height: AppSizes.lg),
                  // AppField(
                  //   hintText: "Birthdate",
                  //   name: "birthDate",
                  //   label: "Birthdate",
                  // ),
                  // const SizedBox(height: AppSizes.lg),
                  AppField<String>(
                    name: 'suburb',
                    label: 'Suburb',
                    hintText: 'Enter suburb',
                    isRequired: true,
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
                    isRequired: true,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
