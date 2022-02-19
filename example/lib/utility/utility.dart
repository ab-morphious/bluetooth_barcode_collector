import 'package:hive/hive.dart';

class Utility {
  static String token = "";
  static final String FIRST_TIME = "first_time";

  static dynamic getHive() async {
    final hive = await Hive.openBox(FIRST_TIME);
    return hive;
  }

  static Future<bool> isFirstTime() async {
    // Obtain shared preferences.
    var isFirst = getHive().get(FIRST_TIME) ?? true;
    return isFirst;
  }

  static void setNotNewUserAnymore() async {
    getHive().put(FIRST_TIME, false);
  }
}
