import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_system/AppColors.dart';
import 'package:student_system/login/logic.dart';
import 'package:student_system/model/manager.dart';
import 'package:student_system/pages/account_setting/view.dart';
import '../component/app_draw.dart';
import '../pages/activity_all/view.dart';
import 'logic.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final logic = Get.find<HomeLogic>();
  var selectedIndex = 0;
  List<Widget> pages=[
    const ActivityAllPage(),
    AccountSettingPage()

  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          drawer: const SideMenu(),
          body: SafeArea(
            child: Row(
              children: [
                SafeArea(
                  child: SizedBox(
                    width: 150,
                    child: NavigationRail(
                      backgroundColor: AppColors.primaryColor,
                      extended: false,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Text(
                            "活动一览",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                          label: Text('activity'),
                        ),
                        NavigationRailDestination(
                          icon: Text(
                            "账户设置",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16),
                          ),
                          label: Text('activity'),
                        ),
                      ],
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: pages[selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
