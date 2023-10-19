import 'package:flutter/material.dart';
import 'package:student_system/AppColors.dart';
import 'package:student_system/method.dart';
import 'package:student_system/model/activity.dart';
import 'package:student_system/model/attendance.dart';
import 'package:student_system/model/registrations.dart';
import 'package:student_system/model/student.dart';
import 'package:student_system/request/requests.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard(
      {super.key, required this.activity, required this.student, required this.use});
  final Activity activity;
  final Student student;
  final String use;
  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  List registrations = [];

  List attendances = [];
  bool flag = true;
  getData() async {
    registrations = [];
    attendances = [];
    var res = await AppRequest().queryActivityRegistrations(widget.activity);
    for (var item in res['data']) {
      registrations.add(Registration.fromJson(item));
    }
    res=await AppRequest().queryActivityAttendance(widget.activity);
    for (var item in res['data']) {
      attendances.add(Attendance.fromJson(item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return flag?Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  height: 500,
                  width: double.infinity,
                  child: FutureBuilder(
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
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 450,
                                        height: 450,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFF5F9E9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0C000000),
                                              blurRadius: 15,
                                              offset: Offset(0, 2),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: ListView(
                                          children: [
                                            Center(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('报名学生一览(${registrations.length})'),
                                            )),
                                            registrations.isEmpty?const Padding(
                                              padding: EdgeInsets.all(40.0),
                                              child: Center(child: Text('暂时无人报名',style: TextStyle(color: AppColors.secondaryTextColor),),),
                                            ):Container(),
                                            for (Registration registration
                                                in registrations)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                    width: double.infinity,
                                                    height: 80,
                                                    decoration: ShapeDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                      ),
                                                      shadows: const [
                                                        BoxShadow(
                                                          color:
                                                              Color(0x0C000000),
                                                          blurRadius: 15,
                                                          offset: Offset(0, 2),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                '学号:${registration.student.studentID}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                "姓名：${registration.student.studentName}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                '班级:${registration.student.className}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                "报名时间：${registration.registrationTime.year}/${registration.registrationTime.month}/${registration.registrationTime.day} ${registration.registrationTime.hour}:${registration.registrationTime.minute}:${registration.registrationTime.second}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 450,
                                        height: 450,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFF5F9E9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(18),
                                          ),
                                          shadows: const [
                                            BoxShadow(
                                              color: Color(0x0C000000),
                                              blurRadius: 15,
                                              offset: Offset(0, 2),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: ListView(
                                          children: [
                                            Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('签到学生一览(${attendances.length}/${registrations.length})'),
                                                )
                                            ),
                                            attendances.isEmpty?Padding(
                                              padding: const EdgeInsets.all(40.0),
                                              child: Center(child: Text('暂时无人签到',style: TextStyle(color: AppColors.secondaryTextColor),),),
                                            ):Container(),
                                            for (Attendance attendance in attendances)
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Container(
                                                    width: double.infinity,
                                                    height: 80,
                                                    decoration: ShapeDecoration(
                                                      color: AppColors
                                                          .primaryColor,
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(18),
                                                      ),
                                                      shadows: const [
                                                        BoxShadow(
                                                          color:
                                                          Color(0x0C000000),
                                                          blurRadius: 15,
                                                          offset: Offset(0, 2),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(
                                                          12.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                '学号:${attendance.student.studentID}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                "姓名：${attendance.student.studentName}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            children: [
                                                              Text(
                                                                '班级:${attendance.student.className}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                "签到时间：${attendance.signInTime.year}/${attendance.signInTime.month}/${attendance.signInTime.day} ${attendance.signInTime.hour}:${attendance.signInTime.minute}:${attendance.signInTime.second}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),

                                                        ],
                                                      ),
                                                    )),
                                              ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                );
              });
        },
        child: Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFF5F9E9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 15,
                offset: Offset(0, 2),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('活动ID:${widget.activity.activityID}'),
                      Text('活动名称:${widget.activity.activityName}'),
                      Text(
                          '活动时间:${widget.activity.activityTime.year}-${widget.activity.activityTime.month}-${widget.activity.activityTime.day}'),
                      Text('活动地点:${widget.activity.location}'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.accessibility_new_rounded),
                      Text('组织者:${widget.activity.manager.managerName}'),
                      Text('报名人数: ${widget.activity.participantsCount}'),
                      Text(
                          '活动类型:${widget.activity.activityType.activityTypeName}'),
                    ],
                  ),
                ),
                widget.use=='registrationAble'?ElevatedButton(
                  onPressed: () async {
                    var res = await AppRequest().addRegistration(widget.activity, widget.student);
                    appShowToast(res['message']);
                    if(res['status']=='000001'){
                      setState(() {
                        flag=false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor),
                  child: Text('报名'),
                ):widget.use=='attendanceAble'?
                ElevatedButton(
                  onPressed: () async {
                    var res = await AppRequest().addAttendance(widget.activity, widget.student);
                    appShowToast(res['message']);
                    if(res['status']=='000001'){
                      setState(() {
                        flag=false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor),
                  child: const Text('签到'),
                )
               : Icon(Icons.check,color: AppColors.accentColor,),
              ],
            ),
          ),
        ),
      ),
    ):Container();
  }
}
