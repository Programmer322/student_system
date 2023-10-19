import 'package:get/get.dart';
import 'package:student_system/app_routes.dart';
import 'package:student_system/method.dart';
import 'package:student_system/request/requests.dart';

class LoginLogic extends GetxController {

  String account='';
  String password='';

  doLogin() async {
    try{
      var res = await AppRequest().appLogin(account, password);
      appShowToast(res['message']);
      await box.write('student', res['data']);
      Get.offAllNamed(Routes.HOME);
    }catch(e){
      appShowToast("账号或密码错误");
    }
  }
}
