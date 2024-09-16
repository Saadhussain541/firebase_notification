import 'package:flutter/material.dart';
import 'package:notification/notification_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService notificationService=NotificationService();
  @override
  void initState() {
    // TODO: implement initState
    // notificationService.isTokenRefresh();
    notificationService.firebaseInit(context);
    notificationService.requestNotificationPermission();
    notificationService.getDeviceToken().then((value){
      print('Device Token');
      print(value);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
