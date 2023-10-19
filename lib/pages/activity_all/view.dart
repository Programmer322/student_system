import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:student_system/AppColors.dart';
import 'package:student_system/app_routes.dart';
import 'package:student_system/component/activity_card.dart';
import 'package:student_system/model/activity.dart';
import 'package:student_system/model/student.dart';
import 'package:student_system/request/requests.dart';

import 'logic.dart';

class ActivityAllPage extends StatefulWidget {
  const ActivityAllPage({Key? key}) : super(key: key);
  @override
  State<ActivityAllPage> createState() => _ActivityAllPageState();
}

class _ActivityAllPageState extends State<ActivityAllPage> {
  getData() async {
    logic.activityListRegistrationAble = [];
    logic.activityListAttendanceAble = [];
    logic.activityListFinished = [];

    var res_1 = await AppRequest().queryStudentAttendance(logic.student);
    for (Map json in res_1['data']) {
      logic.activityListFinished.add(Activity.fromJson(json['activity']));
    }
    var res_2 = await AppRequest().queryStudentRegistrations(logic.student);
    for (Map json in res_2['data']) {
      Activity activity = Activity.fromJson(json['activity']);
      if (!logic.activityListFinished.contains(activity)) {
        logic.activityListAttendanceAble.add(activity);
      }
    }
    var res = await AppRequest().queryAllActivity();
    for (Map json in res['data']) {
      Activity activity = Activity.fromJson(json);
      if (activity.activityTime.isAfter(DateTime.now()) &&
          !logic.activityListFinished.contains(activity) &&
          !logic.activityListAttendanceAble.contains(activity)) {
        logic.activityListRegistrationAble.add(activity);
      }
    }
    logic.listMap = {
      "registrationAble": logic.activityListRegistrationAble,
      'attendanceAble': logic.activityListAttendanceAble,
      'finished': logic.activityListFinished
    };
  }

  final logic = Get.put(ActivityAllLogic());
  Status currentIndex = Status.registrationAble;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('活动一览', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          StatusSelect(
              currentIndex: currentIndex,
              onTap: (value) {
                setState(() {
                  currentIndex = value;
                });
              }),
          SizedBox(
            height: 25,
          ),
          FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        '加载失败,请重试',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'MiSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  } else {
                    return logic.listMap[currentIndex.name]!.isEmpty
                        ? SizedBox(
                      height: Get.height-180,
                          child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.accessibility_new,
                                    size: 45,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '暂时还没有活动哦',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                        )
                        : SizedBox(
                      width: double.infinity,
                          height: Get.height-180,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0,right: 10),
                            child: SearchableList<Activity>(
                              emptyWidget:const Center(
                                child: SizedBox(
                                  height: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.accessibility_new,
                                        size: 45,
                                        color: AppColors.primaryColor,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        '暂时还没有活动哦',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor),
                                      ),
                                      Text(
                                        '点击右下角按钮添加活动吧',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              autoFocusOnSearch: false,
                              initialList: logic.listMap[currentIndex.name],
                              builder: (Activity activity)=>ActivityCard(
                              activity: activity,
                              student: logic.student,
                              use: currentIndex.name,
                            ),
                              filter: (value) => logic.listMap[currentIndex.name]
                                  !.where(
                                    (element) =>
                                    element.content.contains(value),
                              )
                                  .toList(),
                              inputDecoration: InputDecoration(
                                labelText: "搜索",
                                filled: true,
                                fillColor: AppColors.brightYellow3,
                                border: const OutlineInputBorder(),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFCADAA8),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCACCA8),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),

                            ),
                          ));

                        //   ListView(
                        //       children: [
                        //         for (Activity activity
                        //             in logic.listMap[currentIndex.name])
                        //           ActivityCard(
                        //             activity: activity, student: logic.student, use: currentIndex.name,
                        //           )
                        //       ],
                        //     ),
                        // );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

enum Status {
  registrationAble,
  attendanceAble,
  finished,
}

class StatusSelect extends StatelessWidget {
  const StatusSelect(
      {super.key, required this.currentIndex, required this.onTap});
  final Status currentIndex;
  final ValueChanged<Status> onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatusItem(
              onPress: () => onTap(Status.registrationAble),
              // icon: AppIcons.icWishList,
              current: currentIndex,
              name: Status.registrationAble),
          StatusItem(
              onPress: () => onTap(Status.attendanceAble),
              // icon: AppIcons.icThem,
              current: currentIndex,
              name: Status.attendanceAble),
          StatusItem(
              onPress: () => onTap(Status.finished),
              // icon: AppIcons.icUser,
              current: currentIndex,
              name: Status.finished),
        ],
      ),
    );
  }
}

class StatusItem extends StatelessWidget {
  const StatusItem(
      {super.key,
      required this.onPress,
      required this.current,
      required this.name});

  final VoidCallback onPress;
  final Status current;
  final Status name;

  @override
  Widget build(BuildContext context) {
    final nameMap = {
      'registrationAble': '报名中',
      'attendanceAble': '待签到',
      'finished': '已完成',
    };
    return Column(
      children: [
        Container(
          width: 90,
          height: 37,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: current == name ? AppColors.accentColor : null,
          ),
          child: TextButton(
            onPressed: onPress,
            child: Text(
              nameMap[name.name]!,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 16,
                fontFamily: 'MiSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
