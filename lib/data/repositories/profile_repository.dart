
abstract class ProfileRepository {
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? nickName,
    String? mobile,
    DateTime? birthday,
    String? suburb,
    String? city,
    String? preferredStore,
  });
}
