import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_router.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/favorite_cubit/favorite_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await initializeApp();
  runApp(const MyApp());
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await handleNotification();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> handleNotification() async {

  // Handling background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Taking permission
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission();

  debugPrint('User granted permission: ${settings.authorizationStatus}');

  // Handling foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      String title = message.notification!.title ?? '';
      String body = message.notification!.body ?? '';
      debugPrint('Message also contained a notification: Title: $title');
      debugPrint('Message also contained a notification: Body: $body');

      showDialog(context: navigatorKey.currentContext!, builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(navigatorKey.currentContext!).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('A new onMessageOpenedApp event was published!');
    debugPrint('Message data: ${message.data}');
    final messageData = message.data;
    if (messageData['product_id'] != null) {
      navigatorKey.currentState!.pushNamed(
        AppRoutes.productDetailsRoute,
        arguments: messageData['product_id'],
      );
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) {
            final cubit = AuthCubit();
            cubit.checkAuth();
            return cubit;
          },
        ),
        BlocProvider<FavoriteCubit>(
          create: (context) {
            final cubit = FavoriteCubit();
            cubit.getFavoriteProducts();
            return cubit;
          },
        ),
      ],
      child: Builder(builder: (context) {
        final authCubit = BlocProvider.of<AuthCubit>(context);

        return BlocBuilder<AuthCubit, AuthState>(
          bloc: authCubit,
          buildWhen: (previous, current) =>
              current is AuthDone || current is AuthInitial,
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'E-commerce App',
              navigatorKey: navigatorKey,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              initialRoute: state is AuthDone
                  ? AppRoutes.homeRoute
                  : AppRoutes.loginRoute,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        );
      }),
    );
  }
}
