import 'package:bloc/bloc.dart';
import 'package:coffix_app/data/repositories/profile_repository.dart';
import 'package:coffix_app/features/auth/data/model/user.dart';
import 'package:coffix_app/features/profile/domain/usecase/update_profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.dart';
part 'profile_cubit.freezed.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit({
    required ProfileRepository profileRepository,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _profileRepository = profileRepository,
       _updateProfileUseCase = updateProfileUseCase,
       super(ProfileState.initial());

  void updateProfile({
    String? firstName,
    String? lastName,
    String? nickName,
    String? mobile,
    DateTime? birthday,
    String? suburb,
    String? city,
    String? preferredStore,
  }) async {
    emit(ProfileState.loading());
    try {
      await _updateProfileUseCase.call(
        UpdateProfileParams(
          firstName: firstName,
          lastName: lastName,
          nickName: nickName,
          mobile: mobile,
          birthday: birthday,
          suburb: suburb,
          city: city,
          preferredStore: preferredStore,
        ),
      );
      emit(ProfileState.success());
    } catch (e) {
      emit(ProfileState.error(message: e.toString()));
    }
  }
}
