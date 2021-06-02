import 'package:nhs_pedometer/constants/shared_pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefRepository {
  static void save({
    String email,
    String name,
    String imageUrl,
    String token
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (email != null) prefs.setString(SharedPrefKey.email, email);
    if (name != null) prefs.setString(SharedPrefKey.name, name);
    if (imageUrl != null) prefs.setString(SharedPrefKey.imageUrl, imageUrl);
    if (token != null) prefs.setString(SharedPrefKey.token, token);
  }
}