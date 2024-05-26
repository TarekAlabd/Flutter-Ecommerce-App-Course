import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models/choose_location_cubit/choose_location_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/location_item_widget.dart';
import 'package:flutter_ecommerce_app/views/widgets/main_button.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ChooseLocationCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your location',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Let\'s find an unforgettable event. Choose a location below to get started:',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: AppColors.grey,
                      ),
                ),
                const SizedBox(height: 36),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.location_on),
                    suffixIcon:
                        BlocConsumer<ChooseLocationCubit, ChooseLocationState>(
                      bloc: cubit,
                      buildWhen: (previous, current) =>
                          current is AddingLocation ||
                          current is LocationAdded ||
                          current is LocationAddingFailure,
                      listenWhen: (previous, current) =>
                          current is LocationAdded ||
                          current is ConfirmAddressLoaded,
                      listener: (context, state) {
                        if (state is LocationAdded) {
                          locationController.clear();
                        } else if (state is ConfirmAddressLoaded) {
                          Navigator.of(context).pop();
                        }
                      },
                      builder: (context, state) {
                        if (state is AddingLocation) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: AppColors.grey,
                            ),
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            if (locationController.text.isNotEmpty) {
                              cubit.addLocation(locationController.text);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Enter your location!'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                    suffixIconColor: AppColors.grey,
                    prefixIconColor: AppColors.grey,
                    hintText: 'Write location: city-country',
                    fillColor: AppColors.grey1,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Select Location',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                  bloc: cubit,
                  buildWhen: (previous, current) =>
                      current is FetchLocationsFailure ||
                      current is FetchedLocations ||
                      current is FetchingLocations,
                  builder: (context, state) {
                    if (state is FetchingLocations) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is FetchedLocations) {
                      final locations = state.locations;

                      return ListView.builder(
                        itemCount: locations.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final location = locations[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: BlocBuilder<ChooseLocationCubit,
                                ChooseLocationState>(
                              bloc: cubit,
                              buildWhen: (previous, current) =>
                                  current is LocationChosen,
                              builder: (context, state) {
                                if (state is LocationChosen) {
                                  final chosenLocation = state.location;
                                  return LocationItemWidget(
                                    onTap: () {
                                      cubit.selectLocation(location.id);
                                    },
                                    location: location,
                                    borderColor:
                                        chosenLocation.id == location.id
                                            ? AppColors.primary
                                            : AppColors.grey,
                                  );
                                }
                                return LocationItemWidget(
                                  onTap: () {
                                    cubit.selectLocation(location.id);
                                  },
                                  location: location,
                                );
                              },
                            ),
                          );
                        },
                      );
                    } else if (state is FetchLocationsFailure) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                  bloc: cubit,
                  buildWhen: (previous, current) =>
                      current is ConfirmAddressLoading ||
                      current is ConfirmAddressLoaded ||
                      current is ConfirmAddressFailure,
                  builder: (context, state) {
                    if (state is ConfirmAddressLoading) {
                      return MainButton(
                        isLoading: true,
                      );
                    }
                    return MainButton(
                      text: 'Confirm Address',
                      onTap: () {
                        cubit.confirmAddress();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
