abstract class ReferralRepository {
  Future<String> createReferral({
    required List<Map<String, dynamic>> recipients,
  });
}
