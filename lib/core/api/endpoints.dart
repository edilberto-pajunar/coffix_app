import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
}
