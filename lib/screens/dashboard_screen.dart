import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../controllers/MenuController.dart';

class DashBoardScreen1 extends StatelessWidget {
  const DashBoardScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuController(),
        ),
      ],
      child: MainScreen(),
    );
  }
}
