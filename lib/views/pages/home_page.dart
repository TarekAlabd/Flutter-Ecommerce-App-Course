import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models/home_cubit/home_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/category_tab_view.dart';
import 'package:flutter_ecommerce_app/views/widgets/home_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.homeCubit});

  final HomeCubit? homeCubit;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final child = SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              unselectedLabelColor:
                  Theme.of(context).colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(
                  text: 'Home',
                ),
                Tab(
                  text: 'Category',
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  HomeTabView(),
                  CategoryTabView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.homeCubit != null) {
      return BlocProvider<HomeCubit>.value(
        value: widget.homeCubit!,
        child: child,
      );
    }

    return BlocProvider<HomeCubit>(
      create: (context) {
        final cubit = HomeCubit();
        cubit.getHomeData();
        return cubit;
      },
      child: child,
    );
  }
}
