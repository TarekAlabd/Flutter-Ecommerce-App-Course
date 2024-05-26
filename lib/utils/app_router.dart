import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/add_new_card_cubit/payment_methods_cubit.dart';
import 'package:flutter_ecommerce_app/view_models/product_details_cubit/product_details_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/add_new_card_page.dart';
import 'package:flutter_ecommerce_app/views/pages/checkout_page.dart';
import 'package:flutter_ecommerce_app/views/pages/custom_bottom_navbar.dart';
import 'package:flutter_ecommerce_app/views/pages/product_details_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeRoute:
        return MaterialPageRoute(
          builder: (_) => const CustomBottomNavbar(),
          settings: settings,
        );

      case AppRoutes.checkoutRoute:
        return MaterialPageRoute(
          builder: (_) => const CheckoutPage(),
          settings: settings,
        );
      case AppRoutes.addNewCardRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => PaymentMethodsCubit(),
            child: const AddNewCardPage(),
          ),
          settings: settings,
        );
      case AppRoutes.productDetailsRoute:
        final String productId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) {
              final cubit = ProductDetailsCubit();
              cubit.getProductDetails(productId);
              return cubit;
            },
            child: ProductDetailsPage(productId: productId),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
