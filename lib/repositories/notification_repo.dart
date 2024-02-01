import 'package:todo_app/exports.dart';
import 'package:http/http.dart' as http;

class NotificationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Firebase In-App Messaging
  FirebaseInAppMessaging fiam = FirebaseInAppMessaging.instance;

  void triggerInAppEvent() async {
    await fiam.triggerEvent('todo');
  }

  // function to request notifications permissions
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted Permission'); // For Android:
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission'); // For IOS:
    } else {
      AppSettings.openAppSettings();
      debugPrint('Permission Denied');
    }
  }

  // Getting device token:  Both for Android and IOS:

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  // If for some reason your device token get expired then you need to refresh it

  // Refresh Token:

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      debugPrint('refresh');
    });
  }

  // Initialization:
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }

      //show notifications when app is active
      if (Platform.isAndroid) {
        //calling this function to handle internation
        initLocalNotifications(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android

      handleMessage(context, message);
    });
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    // Android Notification Channel:
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notifications',
        importance: Importance.max);

    // Android Notification Detail:
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    // For IOS:
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    // Notifications Detail:
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  // Handle Message:
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()));
    }
  }

  //
  Future<void> setupInteractMessage(BuildContext context) async {
    // When App is terminated then this msg will be shown:

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // ignore: use_build_context_synchronously
      handleMessage(context, initialMessage);
    }

    // When App is in background:
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  // Save Token:
  Future saveDeviceToken({required String token}) async {
    try {
      await _firestore
          .collection('tokens')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({
        "token": token,
      });
    } on FirebaseException catch (err) {
      throw Exception(err.message);
    }
  }

  // Get Token:
  Future<Map<String, dynamic>> fetchDeviceToken() async {
    try {
      Map<String, dynamic> map = await _firestore
          .collection('tokens')
          .doc(_firebaseAuth.currentUser!.uid)
          .get()
          .then((DocumentSnapshot snapshot) {
        return <String, dynamic>{
          "token": snapshot['token'] as String,
        };
      });

      return map;
    } on FirebaseException catch (err) {
      throw Exception(err.message);
    }
  }

  // Send Notification:
  Future sendNotification({required String token}) async {
    const String serverKey =
        'AAAA1DVnoMI:APA91bH0_gva5oZesSe-_krSrGF1bwzUyAd_G5ynxyCrFyy_RHVLQWrbMs9DlCj0JAlVUqSdXbR_Fo526ovFJFcpHPzPZQQXV91aF-FhlO85AwRUeMsn-yZ3-GLjC0woG6y-FIbPTta9';
    const String fcmUrl = "https://fcm.googleapis.com/fcm/send";

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'Todo Saved',
            'body': 'Dear user, Your todo has been saved successully.',
          },
          'priority': 'high',
          'to': token,
        },
      ),
    );

    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully');
    } else {
      debugPrint('Notification sending failed');
    }
  }
}
