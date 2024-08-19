import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_router.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/favorite_cubit/favorite_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
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
