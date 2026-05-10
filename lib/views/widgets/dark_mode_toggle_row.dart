import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/theme_cubit/theme_cubit.dart';

class DarkModeToggleRow extends StatelessWidget {
  const DarkModeToggleRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark =
            state is ThemeLoaded && state.themeMode == ThemeMode.dark;
        return Row(
          children: [
            Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            const SizedBox(width: 12),
            const Text('Dark mode'),
            const Spacer(),
            Semantics(
              label: 'Dark mode',
              toggled: isDark,
              child: Switch(
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              ),
            ),
          ],
        );
      },
    );
  }
}
