import 'package:get/get.dart';
import 'package:student_system/model/activity.dart';
import '../../method.dart';
import '../../model/student.dart';

class ActivityAllLogic extends GetxController {
  List<Activity> activityListRegistrationAble=[];
  List<Activity> activityListAttendanceAble=[];
  List<Activity> activityListFinished=[];
  late Student student;
  Map<dynamic,List<Activity>> listMap={};
  @override
  void onInit() {
    student=Student.fromJson(box.read('student'));
    // TODO: implement onInit
    super.onInit();
  }
}
