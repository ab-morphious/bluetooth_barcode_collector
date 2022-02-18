import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility{
   static String token = "";
   static final String FIRST_TIME = "first_time";

   static dynamic getGetXStorage()
   {
      final getXStorage = GetStorage();
      return getXStorage;
   }
   static Future<bool> isFirstTime() async
   {
      // Obtain shared preferences.
      var isFirst = getGetXStorage().read(FIRST_TIME) ?? true;
      return isFirst;
   }

   static void setNotNewUserAnymore() async
   {
     getGetXStorage().write(FIRST_TIME, false);
   }
}