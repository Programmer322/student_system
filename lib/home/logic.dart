import 'package:get/get.dart';
import 'package:student_system/model/manager.dart';
import 'package:student_system/model/student.dart';

import '../method.dart';

class HomeLogic extends GetxController {
late Student student;
@override
  void onInit() {
  student=Student.fromJson(box.read('student'));
  // TODO: implement onInit
    super.onInit();
  }
}
