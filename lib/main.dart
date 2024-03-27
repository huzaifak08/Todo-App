import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:todo_app/exports.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Notifications:
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Firebase Crashlytics:
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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

  // Firebase App Check:
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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppColors.primaryColor,
                selectionHandleColor: AppColors.primaryColor),
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
        // home: const SplashScreen(),
        initialRoute: RouteName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
