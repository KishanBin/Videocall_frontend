

import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:videocall_app/bindings/LoadingScreenBinding.dart';
import 'package:videocall_app/bindings/homeBinding.dart';
import 'package:videocall_app/bindings/videocallBinding.dart';
import 'package:videocall_app/screens/homeScreen.dart';
import 'package:videocall_app/screens/loadingScreen.dart';
import 'package:videocall_app/screens/videocallScreen.dart';

class Routes {

    static final  routes = [
      GetPage(name: '/home', page:() => HomeScreen(), binding: HomeBinding()),
      GetPage(name:'/videocallscreen',page: () => Videocallscreen(),binding: Videocallbinding()),
      GetPage(name:'/loadingScreen', page: () => LoadingScreen(),binding: LoadingScreenBinding()),
    ];
}
