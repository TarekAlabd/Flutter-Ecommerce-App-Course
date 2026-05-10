import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/dark_mode_toggle_row.dart';
import 'package:flutter_ecommerce_app/views/widgets/main_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          bloc: cubit,
          listenWhen: (previous, current) =>
              current is AuthLoggedOut || current is AuthLogOutError,
          listener: (context, state) {
            if (state is AuthLoggedOut) {
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(
                AppRoutes.loginRoute,
                (route) => false,
              );
            } else if (state is AuthLogOutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          buildWhen: (previous, current) => current is AuthLoggingOut,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DarkModeToggleRow(),
                const SizedBox(height: 24.0),
                if (state is AuthLoggingOut)
                  MainButton(
                    isLoading: true,
                  )
                else
                  MainButton(
                    text: 'Logout',
                    onTap: () async => await cubit.logout(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
