import 'package:todo_app/exports.dart';
import 'package:todo_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: Constants.apiKey,
  //         appId: Constants.appId,
  //         messagingSenderId: Constants.messagingSenderId,
  //         projectId: Constants.projectId),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }

  FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
  firebaseAppCheck.activate(androidProvider: AndroidProvider.debug);
  firebaseAppCheck.getToken().then(
        (value) => debugPrint('Token: $value'),
      );

  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint(message.notification!.title.toString());
  debugPrint(message.data.toString());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
          BlocProvider(create: (_) => UserBloc()),
          BlocProvider(create: (_) => TodoBloc()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              textTheme: TextTheme(
                titleLarge: TextStyle(
                  fontSize: getWidth(context) * 0.07,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                ),
                titleMedium: TextStyle(
                  fontSize: getWidth(context) * 0.05,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryColor,
                ),
                titleSmall: TextStyle(
                  fontSize: getWidth(context) * 0.04,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondaryColor,
                ),
              )),
          home: const SplashScreen(),
        ));
  }
}
