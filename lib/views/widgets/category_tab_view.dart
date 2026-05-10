import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final category = dummyCategories[index];
        final colors = _categoryColors(context, index);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () {},
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: colors.$1,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Text(
                      category.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: colors.$2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      '${category.productsCount} Products',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: colors.$2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: dummyCategories.length,
    );
  }

  (Color, Color) _categoryColors(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final styles = <(Color, Color)>[
      (colorScheme.surfaceContainerHigh, colorScheme.onSurface),
      (Colors.green, Colors.white),
      (colorScheme.inverseSurface, colorScheme.onInverseSurface),
      (colorScheme.surfaceContainerHigh, colorScheme.onSurface),
      (Colors.blue, Colors.white),
    ];

    return styles[index % styles.length];
  }
}
