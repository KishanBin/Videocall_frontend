import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocall_app/bindings/homeBinding.dart';
import 'package:videocall_app/controllers/storageService.dart';
import 'package:videocall_app/reusable/showDialog.dart';
import 'package:videocall_app/routes/routes.dart';
import 'package:videocall_app/services/websocket_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync<StorageService>(
    () async => await StorageService().init(),
    permanent: true,
  );

  Get.put(WebsocketServices(), permanent: true);

  Get.put(showDialogBoxController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialBinding: HomeBinding(),
      initialRoute: '/home',
      getPages: Routes.routes,
    );
  }
}
