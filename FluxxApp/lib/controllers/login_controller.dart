
import 'package:get/get.dart';
import '../backend/database/db_helper.dart';
import '../backend/services/api_service.dart';

class LoginController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var isRegistered = false.obs;

  Future<void> registerUser(String name, String email, String password) async {
    final success = await APIService.register(name, email, password);
    if (success) {
      await DBHelper.saveUserInfo({'name': name, 'email': email});
      userName.value = name;
      userEmail.value = email;
      isRegistered.value = true;
    }
  }

  Future<bool> validateLogin(String email, String password) async {
    final success = await APIService.login(email, password);
    if (success) {
      final userInfo = await DBHelper.getUserInfo();
      userName.value = userInfo['name'];
      userEmail.value = userInfo['email'];
      return true;
    }
    return false;
  }
}
