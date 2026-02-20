import 'package:coffix_app/data/repositories/profile_repository.dart';
import 'package:coffix_app/domain/usecases/use_case.dart';

class UpdateProfileParams {
  final String? firstName;
  final String? lastName;
  final String? nickName;
  final String? mobile;
  final DateTime? birthday;
  final String? suburb;
  final String? city;
  final String? preferredStore;

  UpdateProfileParams({
    this.firstName,
    this.lastName,
    this.nickName,
    this.mobile,
    this.birthday,
    this.suburb,
    this.city,
    this.preferredStore,
  });
}

class UpdateProfileUseCase implements UseCase<void, UpdateProfileParams> {
  final ProfileRepository _profileRepository;

  UpdateProfileUseCase({required ProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<void> call(UpdateProfileParams params) async {
    await _profileRepository.updateProfile(
      firstName: params.firstName,
      lastName: params.lastName,
      nickName: params.nickName,
      mobile: params.mobile,
      birthday: params.birthday,
      suburb: params.suburb,
      city: params.city,
      preferredStore: params.preferredStore,
    );
  }
}
