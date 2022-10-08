import 'package:admin/screens/login_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/MenuController.dart';
import '../../AllFeedback.dart';
import '../../DefaultScreen.dart';
import '../../MangeSubDevision.dart';
import '../../SettingsScreen.dart';
import '../../SubdevisionFeddback.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int level = 0;

  @override
  void initState() {
    getLevel();
    super.initState();
  }

  getLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("level")){
      level = prefs.getInt("level")!;
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            // svgSrc: "assets/icons/menu_profile.svg",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              // Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MultiProvider(
              //   providers: [
              //     ChangeNotifierProvider(
              //       create: (context) => MenuController(),
              //     ),
              //   ],
              //   child: DefaultScreen(),
              // ),));

              Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuController(),
                  ),
                ],
                child: DefaultScreen(),
              ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,),);

            },
          ),
          level==0?DrawerListTile(
            title: "Feedbacks",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuController(),
                  ),
                ],
                child: MainScreen(),
              ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,),);


            },
          ):Container(),
          // DrawerListTile(
          //   title: "Transaction",
          //   svgSrc: "assets/icons/menu_tran.svg",
          //   press: () {},
          // ),
          // DrawerListTile(
          //   title: "Task",
          //   svgSrc: "assets/icons/menu_task.svg",
          //   press: () {},
          // ),
          // DrawerListTile(
          //   title: "Documents",
          //   svgSrc: "assets/icons/menu_doc.svg",
          //   press: () {},
          // ),
          // DrawerListTile(
          //   title: "Store",
          //   svgSrc: "assets/icons/menu_store.svg",
          //   press: () {},
          // ),
          // DrawerListTile(
          //   title: "Notification",
          //   svgSrc: "assets/icons/menu_notification.svg",
          //   press: () {},
          // ),

          level == 0 ? DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {

              Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuController(),
                  ),
                ],
                child: SettingsScreen(),
              ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,),);

            },
          ) : Container(),

          level == 1 ? DrawerListTile(
            title: "Manage Subdivision",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {

              Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (context) => MenuController(),
                  ),
                ],
                child: MangeSubDevision()
              ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,),);


            },
          ) : Container(),

          level == 1 ? DrawerListTile(
            title: "Feedback",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {

              Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => MenuController(),
                    ),
                  ],
                  child: SubDevisionFeddback()
              ),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero,),);


            },
          ) : Container(),

          level == 2 ? DrawerListTile(
            title: "Manage District",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {

            },
          ) : Container(),

          level == 3 ? DrawerListTile(
            title: "Manage State",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {

            },
          ) : Container(),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_setting.svg",
            press: ()=>showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      // Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MultiProvider(
                        providers: [
                          ChangeNotifierProvider(
                            create: (context) => MenuController(),
                          ),
                        ],
                        child: LoginScreen(),
                      ),));
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            // press: () async {
            //
            //   SharedPreferences prefs = await SharedPreferences.getInstance();
            //   prefs.clear();
            //   // Navigator.of(context).pop();
            //   Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MultiProvider(
            //     providers: [
            //       ChangeNotifierProvider(
            //         create: (context) => MenuController(),
            //       ),
            //     ],
            //     child: LoginScreen(),
            //   ),));
            // },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
