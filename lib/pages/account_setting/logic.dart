import 'package:get/get.dart';

import '../../method.dart';
import '../../model/student.dart';

class AccountSettingLogic extends GetxController {
  late Student student;
  Map listMap={};
  @override
  void onInit() {
    student=Student.fromJson(box.read('student'));
    // TODO: implement onInit
    super.onInit();
  }
}
